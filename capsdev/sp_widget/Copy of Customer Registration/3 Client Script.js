function ($scope, $rootScope, $timeout, spUtil, $location, $window) {
    var c = this;

    c.captchaVerified = false;
    c.policy = false;


    var lang = navigator.language;
    if (/^en\b/.test(navigator.language)) {
        c.data.language = 'en';
    }

    if (/^fr\b/.test(navigator.language)) {
        c.data.language = 'fr';
    }

    c.first_name = '';
    c.last_name = '';
    c.email = '';
    c.phone = '';
    c.dom = 'example.com';
		c.isvalidEmail = true;
		c.isvalidSecondaryEmail = true;
    //forgotpass
    c.options = {
        placeholder: c.data.sc,
        allowClear: 'true'
    }

    c.toggle = function () {
			c.email = c.email.split("@")[0];
	
			try {
				c.email_perso = c.email_perso.split("@")[0];	
				c.isvalidSecondaryEmail = /^[a-zA-Z0-9._]+[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/.test(c.email_perso);

			} catch(error) {
				//console.log("catch");
			}
			
			c.isvalidEmail = /^[a-zA-Z0-9._]+[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/.test(c.email);
		}

    c.setSelectedCompany = function (selectedValue) {
        c.domainName = '-1';// for non choice in domain select

        //var g_form = new GlideForm();
        if (selectedValue == 20) {
            //g_form.showFieldMsg("company", "nope", 'error');
            //$scope.g_form.showFieldMsg("company", "nope", 'error');
        } else {
            //g_form.hideFieldMsg("company");
        }

        if (selectedValue != null) {

            c.dom = 'example.com';//give the user a hint before chosing the domain
            c.selectedCompany = selectedValue - 1;

            c.singleDomaine = (c.data.list[c.selectedCompany].domaines.length > 1);//check if the company has only one domain
            if (c.singleDomaine == false) {
                c.domainName = c.dom = c.data.list[c.selectedCompany].domaines[0].label;//if the company have one domaine select it as the default value
            }


        }


    };


    CustomEvent.observe('sn_csm_captcha_verified', function (obj) {
        c.captchaVerified = obj.captchaVerified;
        c.grc = obj.grc;
        scope.$apply();
    });
    c.showSubmit = function () {
        //console.log(c.domainName);
        //console.log(c.domainName=="-1");
			
        if (c.data.enableCaptcha == 'false')
            return !(c.first_name && c.policy == true && c.last_name && c.email && c.company && c.domainName != "-1" && c.data.language && c.dom != "@example.com" && c.dom != "ca-ps.com");
        else
            return !((c.first_name && c.policy == true && c.captchaVerified == true && c.last_name && c.isvalidEmail && c.isvalidSecondaryEmail
											&& c.grc && c.company && c.domainName != "-1" && c.data.language && c.dom != "@example.com" && c.dom != "ca-ps.com")
										 || (c.data.procedureChoice.toString() == "forgotpass" && c.domainName && c.isvalidEmail
												 && c.captchaVerified == true && c.dom != "@example.com" && c.dom != "ca-ps.com"));
			
    };
    c.action = function () {

        c.data.action = 'register';
        c.data.first_name = c.first_name;
        c.data.last_name = c.last_name;
        c.data.email = c.email + '@' + c.dom;
        c.data.phone = c.phone;
        if (c.email_perso) {
            c.data.email_perso = c.email_perso + '@' + c.dom;
        }

        c.data.code = c.code;
        c.data.company = c.company;
        //c.data.procedureChoice = c.procedureChoice;

        c.data.grc = c.grc;
        c.server.update().then(function (response) {
            var data = response["result"];
            if (response.status == 'success') {
                c.success = response["message"];
                $timeout(function () {
                    $location.url('/' + $scope.portal.url_suffix);
                }, 5000);
            } else if (response.status == 'error') {
                c.success = 'There was an error processing your request';
            }
        });
    };
    $scope.registrationInit = function () { };


}