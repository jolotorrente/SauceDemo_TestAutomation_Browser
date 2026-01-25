*** Settings ***
Library    Browser
Library    Collections
Library    String

### Resource List of Keywords ###
Resource        ../Keywords/Login_keywords.robot
Resource        ../Keywords/Logout_keywords.robot

### Resource List of Variables ###
Resource        ../Variables/Login_variables.robot

*** Keywords ***
######################################
## Common Global Component Keywords ##
######################################

# This keyword Launches the Test Website (saucedemo.com) with defined Browser Settings
Launch Website
    New Browser                                     ${BROWSER}    headless=${HEADLESS}
    New Page                                        ${TEST_URL}
    Set Viewport Size                               1920    1080
    Wait For Elements State                         //*[@id='user-name']    visible



#This keyword is Logins the user to the Test Website (saucedemo.com)
User Login
    [Arguments]    ${username}    ${password}
    Take Screenshot                                 ${SCREENSHOT_LOGIN_DIR}/login-start.png
    Fill Text                                       //*[@id='user-name']    ${username}
    Fill Text                                       //*[@id='password']     ${password}
    Click                                           //*[@id='login-button']
    ${loginstatus}=    Run Keyword And Return Status
    ...    Wait For Elements State                  //*[@class='app_logo' and text()='Swag Labs']    visible
    IF    ${loginstatus}
        Validate Successful Login
    ELSE
        Validate Failed Login
    END


# This keyword Logouts the user from the Test Website (saucedemo.com)
User Logout
    Wait For Elements State                          //*[@class='app_logo']    visible
    Open Burger Menu
    Click                                           //*[@id='logout_sidebar_link']
    Wait For Elements State                          //*[@id='user-name']      visible
    Validate Successful Logout


# This keyword Displays the Shopping Cart
Open Cart
    Wait For Elements State                          //*[@class='app_logo']    visible
    # Declare OpenCart button XPath to ${cart_btn} variable
    ${cart_btn}=    Set Variable                     //*[@id='shopping_cart_container']
    Scroll To                                       ${cart_btn}
    Wait For Elements State                          ${cart_btn}    visible
    Click                                           ${cart_btn}
    Wait For Elements State                          //*[@class='title' and text()='Your Cart']    visible


# This keyword Opens the Burger Menu by selecting the Burger button
Open Burger Menu
    Wait For Elements State                          //*[@class='bm-burger-button']    visible
    Click                                           //*[@class='bm-burger-button']
    Wait For Elements State                          //*[@class='bm-menu']             visible


# This keyword Returns from Shopping Cart to Shopping page
Return to Shopping
    Wait For Elements State                          //*[@id='continue-shopping']    visible
    Click                                           //*[@id='continue-shopping']
    Wait For Elements State                          //*[@class='title' and text()='Products']    visible