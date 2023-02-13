(function ($sp, input, data, options) {
	// data.captch_url = 'https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit&hl=' + gs.getSession().getLanguage();
	data.enableCaptcha = gs.getProperty('sn_customerservice.captchaEnabled');
	data.captchaSiteKey = gs.getProperty('caps.recaptcha.site-key');
	var captchaSiteKeySecret = gs.getProperty('caps.recaptcha.site-key.secret');

	data.captch_url = 'https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit&hl=' + gs.getSession().getLanguage();
	data.captchaSiteKeyv2 = gs.getProperty('google.captcha.site_key');

	data.enableV2Captcha = input && input.enabledV2Captcha ? input.enabledV2Captcha : false;

	if (input && data.enableV2Captcha == true) {
		var trueCaptcha = new global.CSManagementUtils().verifyCaptcha(input.grc);
	}

	if(input && data.enableV2Captcha == false) {
		data.captchaResponse = responseTokenRecaptcha(input.captchaToken);
		if(data.captchaResponse.score < 0.5) {
			data.enableV2Captcha = true;
			return data;
		}
	}

	if (input && input.action == 'register' && input.name_society_tech && input.automate_num && +input.automate_num && checkEmail(input.mail) && input.panne_description && input.phone && checkPhone(input.phone)) {
		if ((data.captchaResponse.success == true && data.captchaResponse.score > 0.5) || trueCaptcha) {
			gr = new GlideRecord('incident');
			gr.initialize();
			gr.applyTemplate('PRODUCTION PFA SUPPORT ALBI - PORTAIL');//MODELES INCIDENT AUTOMATE UNITAIRE

			var inc_desc = '';
			var lastNumber = input.automate_num.substr(input.automate_num.length - 5);
			var gr_customerAccount;

			var entities = [['HSBC', 'LCL', 'Chabières', 'Chalus'], ['30056', '30002', '41539', "10188"]];

			if (entities[1].indexOf(lastNumber) != -1) {
				inc_desc += 'Entité = ' + entities[0][entities[1].indexOf(lastNumber)];
			} else {
				gr_customerAccount = new GlideRecord('customer_account');
				gr_customerAccount.addQuery('parent', "6cd347521b18849063b9dc29cd4bcb4a");
				gr_customerAccount.addEncodedQuery('nameLIKE' + lastNumber);
				gr_customerAccount.query();
				gr_customerAccount.next();
				if (gr_customerAccount.name == '') {
					data.status = "error";
					gs.addErrorMessage(gs.getMessage('Mauvais numéro automate'));
					return data;
				}
				inc_desc += 'Entité = ' + gr_customerAccount.name;
			}

			inc_desc = inc_desc + '\nNuméro Automate = ' + input.automate_num;
			inc_desc = inc_desc + '\nNom interlocuteur = ' + input.name_society_tech + " / " + input.mail;
			inc_desc = inc_desc + '\nTéléphone = ' + input.phone;
			inc_desc = inc_desc + '\nObjet de la demande = AppelTech - ' + input.panne_description;

			gr.setValue('description', inc_desc);
			gr.setValue('u_date_de_d_tection_de_l_incident', new GlideDateTime());
			gr.caller_id = "appeltech@caps.com";

			var sys_id = gr.insert();
			if (!gs.nil(sys_id)) {
				data.sys_id = sys_id;
				data.inc_number = gr.number.toString();
				data.status = "success";
				data.message = gs.getMessage("Your request has been submitted and is pending review. You will receive an email when your request is processed.");

				var json = {
					"ref": gr.number.toString(),
					"description": input.panne_description,
					"automate_number": input.automate_num,
					"phone": input.phone,
					"name_society_tech": input.name_society_tech
				};
				var jsonString = JSON.stringify(json);
				gs.eventQueue("appeltech.sendnotif", current, input.mail, jsonString);
			} else {
				data.status = "error";
				gs.addErrorMessage(gs.getMessage('Erreur lors de l\'insert'));
			}
			return data;
		} else {
			if(input.enabledV2Captcha == false) {
				data.enableV2Captcha = true;
				gs.addErrorMessage(gs.getMessage('Robot détecté, passage en captcha v2'));
			} else {
				gs.addErrorMessage(gs.getMessage('Une erreur de captcha est survenue'));
			}
			data.status = "error";
			return data;
		}
	}


	function checkEmail(email) {
		const isvalidEmail = email && /\S+@\S+\.\S+/.test(email);
		return true;
		//return isvalidEmail;
	}

	function checkPhone(phone) {
		const isvalidPhone = /^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$/.test(phone);
		return isvalidPhone;
	}

	function responseTokenRecaptcha(token) {
		const data = {}
        try {
            var RESTCAPTCHA = new sn_ws.RESTMessageV2();
            RESTCAPTCHA.setHttpMethod('post');
            RESTCAPTCHA.setEndpoint('https://www.google.com/recaptcha/api/siteverify');
            RESTCAPTCHA.setQueryParameter('secret', captchaSiteKeySecret); //gs.getProperty('recaptcha.secret-key')
            RESTCAPTCHA.setQueryParameter('response', token);
            var captchaResponse = RESTCAPTCHA.execute();
            if (captchaResponse.haveError()) {
                gs.addErrorMessage('Error in validating captcha response: ' + captchaResponse.getErrorMessage() + '. Status code: ' + captchaResponse.getStatusCode(), 'CaptchaAjax script include');
                data.captchaResponse = {
					status: "error",
				};
            }
            var successResponse = captchaResponse.getBody(); //Relies on ES5 syntax. For ES3, use new JSON().decode(json_string);
            data.captchaResponse = JSON.parse(successResponse);
        } catch (ex) {
            gs.addErrorMessage('Error in processing response from reCAPTCHA: ' + ex.message, 'CaptchaAjax script include');
			data.captchaResponse = {
				status: "error",
			};
        }
		return data.captchaResponse;
	}
	//Desactivation du formulaire le samedi/dimanche
	var date = new Date().getDay();
	if(date==6 || date==0){ //6==samedi 0==dimanche
		data.display = true;
	}else{
		data.display =false;
	}
	
	
	



})($sp, input, data, options);