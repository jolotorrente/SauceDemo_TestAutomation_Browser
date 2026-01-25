*** Variables ***
#############################
${SCREENSHOT_LOGOUT_DIR}            C:/Test_Automation_Compilation/SauceDemo_Test_Automation_Browser/reports/screenshots/Logout
${ERROR_LOCATOR}                    xpath://*[@class='error-message-container error']

######################################
## List Variable of Protected Pages ##
######################################
@{PROTECTED_PAGES}
...    https://www.saucedemo.com/inventory.html
...    https://www.saucedemo.com/cart.html
...    https://www.saucedemo.com/checkout-step-one.html
...    https://www.saucedemo.com/checkout-step-two.html
...    https://www.saucedemo.com/checkout-complete.html