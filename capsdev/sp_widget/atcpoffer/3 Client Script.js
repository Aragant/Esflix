function ($scope, $rootScope, $timeout, spUtil, $location) {
	var c = this;

	if (c.data.is_logged_in) {
		$location.url($scope.portal.url_suffix);
	}

	c.policy = false;


	c.name_society_tech = '';
	c.phone = '';
	c.automate_num = '';
	c.concerned_entity = '';
	c.panne_description = '';
	c.mail = '';
	c.data.enabledV2Captcha = false;

	c.captchaVerified = false;
	c.grc = false;
	CustomEvent.observe('sn_csm_captcha_verified', function (obj) {
		c.captchaVerified = obj.captchaVerified;
		c.grc = obj.grc;
		scope.$apply();
	});


	function loadScript(url, callback) {
		// Adding the script tag to the head as suggested before
		var divScript = document.getElementById("script-captcha");
		var script = document.createElement('script');
		script.type = 'text/javascript';
		script.src = url;
		script.defer = true;
		script.async = true;

		// Then bind the event to the callback function.
		// There are several events for cross browser compatibility.
		script.onreadystatechange = callback;
		script.onload = callback;

		// Fire the loading
		divScript.innerHTML = "";
		divScript.appendChild(script);
	}

	var loadedScript = function () {
	};

	if (c.data.enableV2Captcha) {
		loadScript("https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit", loadedScript);
	} else {
		loadScript("https://www.google.com/recaptcha/enterprise.js?render=" + c.data.captchaSiteKey, loadedScript);
	}



	c.showSubmit = function () {

		if (c.data.enableCaptcha == 'false')
			return !(c.name_society_tech.split(' ').length > 1 && c.policy == true && c.automate_num && c.automate_num.toString().length == 13 && +c.automate_num && c.checkEmail() && c.checkPhoneNumber());
		else
			return !(c.name_society_tech.split(' ').length > 1 && c.policy == true && c.panne_description.length > 1 && c.automate_num && c.automate_num.toString().length == 13 && + c.automate_num && c.checkEmail() && c.checkPhoneNumber());
	};

	c.enableCaptcha = function () {
		return !(c.name_society_tech.split(' ').length > 1 && c.policy == true && c.automate_num && c.automate_num.toString().length == 13 && +c.automate_num && c.checkPhoneNumber());
	};

	c.checkPhoneNumber = function () {
		const isPhoneNumber = /^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$/.test(c.phone);
		return isPhoneNumber;
	}

	c.checkEmail = function () {
		const isvalidEmail = /\S+@\S+\.\S+/.test(c.mail);
		return true;
		//return isvalidEmail;
	}

	c.switchToCaptchaV2 = function () {

	}

	c.action = function () {
		if (c.data.enableV2Captcha) {
			c.data.action = 'register';
			c.data.name_society_tech = c.name_society_tech;
			c.data.phone = c.phone;
			c.data.automate_num = c.automate_num.toString();
			c.data.panne_description = c.panne_description;
			c.data.mail = c.mail;

			// c.data.captchaToken = token;

			c.data.grc = c.grc;
			c.server.update().then(function (response) {
				console.log(response);
				if (response.status == 'success') {
					c.success = response["message"];
					$location.url('/interv_automate?temp=1&id=atcp_congrats&inc_id=' + c.data.inc_number + "&mail=" + c.data.mail);
				} else if (response.status == 'error') {
					c.success = 'There was an error processing your request';
					console.log(response);
				}
			});
		} else {
			grecaptcha.enterprise.ready(function () {
				grecaptcha.enterprise.execute(c.data.captchaSiteKey, { action: 'appeltech' }).then(function (token) {
					c.data.action = 'register';
					c.data.name_society_tech = c.name_society_tech;
					c.data.phone = c.phone;
					c.data.automate_num = c.automate_num.toString();
					c.data.panne_description = c.panne_description;
					c.data.mail = c.mail;
					
					c.data.captchaToken = token;
					
					c.data.grc = c.grc;
					c.server.update().then(function (response) {
						console.log(response);
						if (response.status == 'success' && response.captchaResponse.success == true && response.captchaResponse.score > 0.5) {
							c.success = response["message"];
							$location.url('/interv_automate?id=atcp_congrats&inc_id=' + c.data.inc_number + "&mail=" + c.data.mail);
						} else if (response.status == 'error' || response.enableV2Captcha == true) {
							c.success = 'There was an error processing your request';
							c.data.enabledV2Captcha = true;
							loadScript("https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit", loadedScript);
							c.server.update().then(function (response) {
							});

						}
					});
				});
			});
		}
	};

}