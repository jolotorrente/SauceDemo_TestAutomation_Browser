*** Variables ***
#############################
${TEST_URL}                         https://www.saucedemo.com/
${BROWSER}                          chromium
${HEADLESS}                         False
${SCREENSHOT_LOGIN_DIR}             C:/Users/jolo_/PycharmProjects/SauceDemo_TestAutomation_Puppeteer/Test_Automation/reports/creenshots/Login

###########################
## USER TYPES AND INPUTS ##
###########################
${USERNAME}                         standard_user
${INVALID_USERNAME}                 standard-user
${LOCKED_USERNAME}                  locked_out_user
${PASSWORD}                         secret_sauce
${INVALIDPASSWORD}                  secret-sauce
${NULL}                             ${EMPTY}
@{INPUT_VALIDATION}                 123qwe!@#  123098  hello world  @$@&$@!@$%.,  1 a ^

##########################
## LIST OF LOGIN ERRORS ##
##########################
&{LOGIN_ERRORS}
...  invalid=Epic sadface: Username and password do not match any user in this service
...  locked=Epic sadface: Sorry, this user has been locked out.
...  emptyuser=Epic sadface: Username is required
...  emptypass=Epic sadface: Password is required
...  loggedout=Epic sadface: You can only access '/inventory.html' when you are logged in.