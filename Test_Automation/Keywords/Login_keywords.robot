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
    ${expected_elements}=    Create List
    ...    id=react-burger-menu-btn
    ...    xpath=//*[@class='title' and text()='Products']
    ...    css=.shopping_cart_link
    ...    css=.product_sort_container

    # Browser library automatically waits for the state to be visible
    Wait For Elements State    xpath=//*[@class='app_logo' and text()='Swag Labs']    visible

    FOR    ${elem}    IN    @{expected_elements}
        Wait For Elements State    ${elem}    visible
    END
    Set Test Message    User was able login successfully.   append=yes

# Validates that user login was NOT successful
Validate Failed Login
    ${actualerror}=    Get Text    css=.error-message-container.error
    ${matched}=    Set Variable    ${False}
    FOR    ${key}    ${expected_error}    IN    &{LOGIN_ERRORS}
        IF    '${actualerror}' == '${expected_error}'
            # In Browser library, we can check visibility and text in one line using assertions
            Wait For Elements State    css=.error-message-container.error    visible
            Get Text    css=.error-message-container.error    ==    ${expected_error}

            ${matched}=    Set Variable    ${True}
            Set Test Message    Error Occurred: ${actualerror}   append=yes
            Exit For Loop
        END
    END
    IF    not ${matched}
        Fail    Error Flow Not Yet Covered. Please create a New Test Case for Uncovered Error Message
    END

# Validates login input fields accept valid characters
Validate Input Fields
    [Arguments]    @{input}
    FOR    ${newinput}    IN    @{input}
        Fill Text    id=user-name    ${newinput}
        # Get Property with an assertion (==) replaces Should Be Equal
        Get Property    id=user-name    value    ==    ${newinput}
        Clear Text    id=user-name
    END
    FOR    ${newinput}    IN    @{input}
        Fill Text    id=password    ${newinput}
        Get Property    id=password    value    ==    ${newinput}
        Clear Text    id=password
    END

# Validates existence and states of login page elements
Validate Login Page Elements
    ${login_elements}=    Create List
    ...    id=user-name
    ...    id=password
    ...    id=login-button
    FOR    ${elem}    IN    @{login_elements}
        # Validates visibility and enabled state using modern assertions
        Wait For Elements State    ${elem}    visible
        Get Element States    ${elem}    contains    enabled
    END

    Wait For Elements State    css=.login_logo    visible
    # Direct assertions: Gets value and compares in one step
    Get Text         css=.login_logo    ==    Swag Labs
    Get Attribute    id=user-name       placeholder    ==    Username
    Get Attribute    id=password        placeholder    ==    Password
    Get Attribute    id=login-button    value          ==    Login