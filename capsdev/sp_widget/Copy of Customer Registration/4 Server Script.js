(function($sp, input, data, options) {
	var procedureChoice = $sp.getParameter('procedure_choice');
	data.procedureChoice = procedureChoice;
	data.is_logged_in = gs.getSession().isLoggedIn();
	data.sys_id = '-1';
	data.list=[];
	data.sc=gs.getMessage('your company');
	data.domaines = [];
	var e={};
	var gr=new GlideRecord('customer_account');
	gr.addEncodedQuery('name!=NULL^u_domaine!=NULL^u_active=true');
	gr.orderBy('name');
	gr.query();
	var domains;
	
	var i=1;
	while(gr.next()){
		domains = [];
		e={};
		e.value=i;
		e.label=gr.getValue('name');
		e.sys_id=gr.getUniqueValue();
		e.mail= gr.getValue('u_domaine');
		e.domaines = [];
		
		domains = gr.getValue('u_domaine').split(',');
		for (var j = 0 ; j < domains.length ; j ++){
			//data.domaines.push({value : j, label: domains[j],companyValue : i ,companyName : e.label});
			e.domaines.push({value : j, label: domains[j]});
			//data.domaines.push('test');
		}

		data.list.push(e);
		i++;
	}
		
	
	data.captch_url= 'https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit&hl=' + gs.getSession().getLanguage();
	data.enableCaptcha = gs.getProperty('sn_customerservice.captchaEnabled');
	data.captchaSiteKey = gs.getProperty('google.captcha.site_key');
	
	var trueCaptcha = new global.CSManagementUtils().verifyCaptcha(input.grc);
	
	var user = gs.getUser();
	var result = {};
	
	if (input && input.action == 'register' && input.first_name && input.last_name && input.email && input.company) {
		if(trueCaptcha) {
			gr = new GlideRecord('sn_customerservice_registration');
			gr.initialize();
			
			gr.setValue('first_name', input.first_name);
			//gr.setValue('u_langue',gs.getSession().getLanguage());
			gr.setValue('u_langue',input.language);
			gr.setValue('last_name', input.last_name);
			
			gr.setValue('email', input.email);
			gr.setValue('account',data.list[input.company-1].sys_id);
			gr.setValue('u_phone',input.phone);
			if(input.email_perso ){
				
				gr.setValue('u_email_notification',input.email_perso);
			}else
			gr.setValue('u_email_notification','');
			
			//gr.setValue('registration_code', input.code);
			var sys_id = gr.insert();
			if(!gs.nil(sys_id)) {
				data.sys_id = sys_id;
				data.status = "success";
				data.message = gs.getMessage("Your request has been submitted and is pending review. You will receive an email when your request is processed.");
			} else {
				data.status = "error";
			}
			data.result = result;
			return data;
		} else {
			gs.addErrorMessage(gs.getMessage('Please verify the security code.'));
			data.status = "error";
			return data;
		}	
	}
	if(input && input.procedureChoice.toString() === "forgotpass" && input.email) {
		if(trueCaptcha) {
			var gr_user = new GlideRecord('sys_user');
			gr_user.addEncodedQuery('email=' + input.email);
			gr_user.query();
			while(gr_user.next()) {
				gr = new GlideRecord('sn_customerservice_registration');
			gr.initialize();
			
			//gr.setValue('first_name', "");
			//gr.setValue('u_langue',gs.getSession().getLanguage());
			//gr.setValue('last_name', "");
			gr.setValue('email', input.email);
			gr.setValue('account',data.list[input.company-1].sys_id);
			
			var sys_id = gr.insert();
			if(!gs.nil(sys_id)) {
				data.sys_id = sys_id;
				data.status = "success";
				data.message = gs.getMessage("Your request has been submitted and is pending review. You will receive an email when your request is processed.");
			} else {
				data.status = "error";
			}
			data.result = result;
			return data;
		
			}
			
			data.message = gs.addErrorMessage(gs.getMessage("Your account doesn't exist. Please, check your syntax."));
			return data;
			
		} else {
			gs.addErrorMessage(gs.getMessage('Please verify the security code.'));
			data.status = "error";
			return data;
		}		
	}
	
})($sp, input, data, options);