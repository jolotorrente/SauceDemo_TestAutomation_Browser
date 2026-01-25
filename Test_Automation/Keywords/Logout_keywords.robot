*** Settings ***
Library         Browser
Library         String

### Resource List of Keywords ###
Resource        ../Keywords/Global_keywords.robot

### Resource List of Variables ###
Resource        ../Variables/Login_variables.robot
Resource        ../Variables/Logout_variables.robot

### Documentation ###
Documentation   This Keyword Robot File is a compilation Logout functionality
...             Logout to Website
...             Security Checks after Proper Logout

*** Keywords ***
###############################
## Logout Component Keywords ##
###############################


# This keyword Validates Logout Session on the Test Website (saucedemo.com)
Validate Successful Logout
    Validate Login Page Elements
    # Validate the Inventory Page Elements are no longer Available after Logout
    ${unexpected_elements}=    Create List
    ...     //*[@id='react-burger-menu-btn']
    ...     //*[@class='title' and text()='Products']
    ...     //*[@class='shopping_cart_link']
    ...     //*[@class='product_sort_container']
    FOR    ${elem}    IN    @{unexpected_elements}
        Wait For Elements State    ${elem}    hidden
    END


# This keyword Validates Logout Session on Back Navigation
Confirm Logout Session on Back Navigation
    # This will try to Navigate Back on the previous page, which was a Logged In State, using a Javascript
    Evaluate JavaScript                             window.history.back()
    # Build Error Message Container XPath
    ${errorcontainer}=    Set Variable              //*[@class='error-message-container error']
    # Verify that Error Occured that user can only access previous page when you are logged in
    Wait For Elements State                         ${errorcontainer}    visible
    ${actualerror}=    Get Text                    ${errorcontainer}
    Element Text Should Be                          ${errorcontainer}    ${actualerror}


# This keyword Validates Logout Session after Page Refresh
Validate Successful Logout after Refresh
    Reload Page
    Validate Login Page Elements


# This keyword Verifies Security Check on Restristed Web Pages that Requires Login (saucedemo.com)
Validate Secured Pages after Logout
    # Build Variable for XPATH locator
    # Build List Variable for the following Webpages
    # For Loop to Navigate to different websites, declared as List Variable, that require Login to verify that pages are Unaccessible
    FOR    ${url}    IN    @{PROTECTED_PAGES}
        Go To                                       ${url}
        Validate Protected Page Error
    END
    # Navigate to a random Product Page
    ${productindex}=    Evaluate                    random.randint(0, 10)    random
    Go To                                           https://www.saucedemo.com/inventory-item.html?id=${productindex}
    Validate Protected Page Error
    Reload Page


# This Keyword is a sub-keyword helper to Validate Protected Pages
Validate Protected Page Error
    Wait For Elements State                         ${ERROR_LOCATOR}    visible
    ${actualerror}=    Get Text                    ${ERROR_LOCATOR}
    Element Text Should Be                          ${ERROR_LOCATOR}    ${actualerror}