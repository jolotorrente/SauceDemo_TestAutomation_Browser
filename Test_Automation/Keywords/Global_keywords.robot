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
    New Browser                                     browser=${BROWSER}    headless=${HEADLESS}
    New Context                                     viewport={'width': 1920, 'height': 1080}
    New Page                                        ${TEST_URL}
    Wait For Elements State                         id=user-name        visible    timeout=5s


#This keyword Logins the user to the Test Website (saucedemo.com)
User Login
    [Arguments]    ${username}    ${password}
    Take Screenshot                                 ${SCREENSHOT_LOGIN_DIR}/login-start.png
    Fill Text                                       id=user-name        ${username}
    Fill Text                                       id=password         ${password}
    Click                                           id=login-button
    Validate Successful Login


# This keyword Logouts the user from the Test Website (saucedemo.com)
User Logout
    Wait For Elements State                         css=.app_logo       visible
    Open Burger Menu
    Click                                           id=logout_sidebar_link
    Wait For Elements State                         id=user-name        visible    timeout=5s
    Validate Successful Logout


# This keyword Displays the Shopping Cart
Open Cart
    Wait For Elements State                         css=.app_logo    stable    timeout=5s
    Click                                           id=shopping_cart_container
    Wait For Elements State                         //*[@class='title' and text()='Your Cart']    visible    timeout=5s


# This keyword Opens the Burger Menu by selecting the Burger button
Open Burger Menu
    Click                                           css=.bm-burger-button
    Wait For Elements State                         css=.bm-menu    visible     timeout=5s


# This keyword Returns from Shopping Cart to Shopping page
Return to Shopping
    Click                                           id=continue-shopping
    Wait For Elements State                         //*[@class='title' and text()='Products']    stable    timeout=5s