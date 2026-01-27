*** Settings ***
Library         Browser
Library         String

### Resource List of Keywords ###
Resource        ../Keywords/Global_keywords.robot

### Resource List of Variables ###
Resource        ../Variables/Login_variables.robot

### Documentation ###
Documentation   This Keyword Robot File is a compilation Login functionality
...             Login to Website


*** Keywords ***
##############################
## Login Component Keywords ##
##############################

# Validates that user login was successful
Validate Successful Login
    # Optimized: Check the most important element for 'stable' state first
    Wait For Elements State    //*[@class='app_logo' and text()='Swag Labs']    stable    timeout=5s
    ${expected_elements}=  Create List
    ...  id=react-burger-menu-btn
    ...  //*[@class='title' and text()='Products']
    ...  css=.shopping_cart_link
    ...  css=.product_sort_container
    FOR  ${elem}  IN  @{expected_elements}
        # 'stable' is better for UI elements that might have entrance animations
        Wait For Elements State    ${elem}    stable    timeout=2s
    END
    Set Test Message    User was able to login Successfully.   append=yes


#This keyword Attempts to Login to the Test Website (saucedemo.com) with invalid credentials
User Failed Login
    [Arguments]    ${username}    ${password}
    Take Screenshot         ${SCREENSHOT_LOGIN_DIR}/login-start.png
    Fill Text               id=user-name        ${username}
    Fill Text               id=password         ${password}
    Click                   id=login-button
    Validate Failed Login


# Validates that user login was NOT successful
Validate Failed Login
    # Refactor: Wait for visibility first to ensure the element exists before fetching text
    Wait For Elements State         css=.error-message-container.error    visible
    ${actualerror}=  Get Text       css=.error-message-container.error
    # Use BuiltIn 'Should Contain Any' if your LOGIN_ERRORS is a list of expected strings
    # This replaces the entire manual IF/ELSE loop logic
    @{expectederror_list}=    Get Dictionary Values    ${LOGIN_ERRORS}
    Should Contain Any    ${actualerror}    @{expectederror_list}
    ...  msg=Error Flow Not Yet Covered: ${actualerror}
    Set Test Message    Error Occurred: ${actualerror}


# Validates login input fields accept valid characters
Validate Input Fields
    [Arguments]    @{input}
    # Refactor: trust the 'Fill Text' keyword and use 'Clear Text' first to ensure a clean start
    FOR  ${newinput}  IN  @{input}
        Clear Text          id=user-name
        Fill Text           id=user-name        ${newinput}
        # Strict verification only if necessary for your specific audit requirements
        Get Property        id=user-name        value  ==  ${newinput}
    END
    FOR  ${newinput}  IN  @{input}
        Clear Text          id=password
        Fill Text           id=password        ${newinput}
        Get Property        id=password        value  ==  ${newinput}
    END


# Validates existence and states of login page elements
Validate Login Page Elements
    ${login_elements}=    Create List
    ...  id=user-name
    ...  id=password
    ...  id=login-button
    FOR    ${elem}    IN    @{login_elements}
        # Validates visibility and enabled state using modern assertions
        Wait For Elements State    ${elem}    visible
        Get Element States    ${elem}    contains    enabled
    END
    Wait For Elements State    css=.login_logo    visible
    # Direct assertions: Gets value and compares in one step
    Get Text                css=.login_logo    ==    Swag Labs
    Get Attribute           id=user-name       placeholder    ==    Username
    Get Attribute           id=password        placeholder    ==    Password
    Get Attribute           id=login-button    value          ==    Login