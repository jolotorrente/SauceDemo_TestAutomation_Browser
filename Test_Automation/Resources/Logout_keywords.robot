*** Settings ***
Library         Browser
Library         String

### Resource List of Resources ###
Resource        ../Resources/Common_keywords.robot

### Resource List of Variables ###
Resource        ../Resources/Variables/Login_variables.robot
Resource        ../Resources/Variables/Logout_variables.robot

*** Keywords ***
###############################
## Logout Component Resources ##
###############################

# This keyword Validates Logout Session on the Test Website
Validate Successful Logout
    Validate Login Page Elements
    ${unexpected_elements}=  Create List
    ...  id=react-burger-menu-btn
    ...  css=.title >> text=Products
    ...  css=.shopping_cart_link
    ...  css=.product_sort_container
    FOR  ${elem}  IN  @{unexpected_elements}
        Wait For Elements State                         ${elem}    hidden    timeout=5s
    END


# This keyword Validates Logout Session on Back Navigation
Confirm Logout Session on Back Navigation
    Go Back
    ${errorcontainer}=  Set Variable                    css=.error-message-container.error
    Wait For Elements State                             ${errorcontainer}    visible
    # Combined Get Text and Element Text Should Be into one robust assertion
    Get Text                                            ${errorcontainer}  ==  Epic sadface: You can only access '/inventory.html' when you are logged in.


# This keyword Validates Logout Session after Page Refresh
Validate Successful Logout after Refresh
    # Replaced 'Reload Page' with native 'Reload'
    Reload
    Validate Login Page Elements


# This keyword Verifies Security Check on Restricted Web Pages
Validate Secured Pages after Logout
    FOR  ${url}  IN  @{PROTECTED_PAGES}
        Go To    ${url}
        Validate Protected Page Error
    END
    # Navigate to a random Product Page
    ${productindex}=  Evaluate                          random.randint(0, 10)    modules=random
    Go To                                               https://www.saucedemo.com/inventory-item.html?id=${productindex}
    Validate Protected Page Error
    Reload


# Helper sub-keyword with 2026 inline assertion syntax
Validate Protected Page Error
    Wait For Elements State                             ${ERROR_LOCATOR}    visible
    # Browser Library recommendation: Perform the assertion inside the Get Text keyword
    Get Text                                            ${ERROR_LOCATOR}    contains    Epic sadface