*** Settings ***
Library         Browser
Library         String

### Resource List of Keywords ###
Resource        ../Keywords/Global_keywords.robot
Resource        ../Keywords/Inventory_keywords.robot

### Resource List of Variables ###
Resource        ../Variables/Checkout_variables.robot

*** Keywords ***
##################################
##  Checkout Component Keywords ##
##################################

# This Keyword is combined Keyword to Complete Checkout Process
Checkout Cart
    [Arguments]    ${firstname}    ${lastname}    ${postalcode}
    Set Screenshot Directory        ${SCREENSHOT_CHECKOUT_DIR}
    Open Cart
    Validate Cart
    Initiate Checkout
    Supply User Information    ${firstname}    ${lastname}    ${postalcode}
    Finish Checkout


# This Keyword Initiates the 1st Step to Checkout
Initiate Checkout
    ${checkout_btn}=    Set Variable               //*[@id='checkout' and text()='Checkout']
    Scroll To                                   ${checkout_btn}
    Click                                      ${checkout_btn}


# This keyword Validates the Gross Total of Products added to Cart by Adding the Prices of each Product
Validate Cart
    Wait For Elements State                       //*[@id='checkout' and text()='Checkout']    visible
    ${cart_count}=    Get Element Count            //*[@class='inventory_item_price']
    ${total}=    Set Variable                     0
    FOR    ${index}    IN RANGE    1    ${cart_count + 1}
        ${price_text}=    Get Text                xpath:(//*[@class='inventory_item_price'])[${index}]
        ${price}=    Evaluate                     float(${price_text.replace('$','')})
        ${total}=    Evaluate                     ${total} + ${price}
        Set Test Variable                         ${total}
    END
    Sleep    1s


# This keyword Completes the Checkout form with random names and postal code from a List Variable
Supply User Information
    [Arguments]    ${firstname}    ${lastname}    ${postalcode}
    Wait For Elements State                       //*[@class='title' and text()='Checkout: Your Information']    visible
    ${firstname}=    Evaluate                     random.choice(@{FIRST_NAME})    random
    Set Test Variable                             ${firstname}
    ${lastname}=    Evaluate                      random.choice(@{LAST_NAME})     random
    Set Test Variable                             ${lastname}
    ${postalcode}=    Evaluate                    random.choice(@{POSTAL_CODE})   random
    Set Test Variable                             ${postalcode}
    Fill Text                                    //*[@id='first-name']    ${firstname}
    Fill Text                                    //*[@id='last-name']     ${lastname}
    Fill Text                                    //*[@id='postal-code']   ${postalcode}
    IF    '${firstname}' != '' and '${lastname}' != '' and '${postalcode}' != ''
        Validate Complete User Information
    ELSE
        Validate Incomplete User Information Error
    END


# This keyword Validates User Information supplied and Completes the Step 1: User Information of Checkout
Validate Complete User Information
    ${textfirst}=    Get Property                 //*[@id='first-name']    value
    Should Be Equal As Strings                    ${firstname}    ${textfirst}
    ${textlast}=    Get Property                  //*[@id='last-name']     value
    Should Be Equal As Strings                    ${lastname}     ${textlast}
    ${textpostal}=    Get Property                //*[@id='postal-code']   value
    Should Be Equal As Strings                    ${postalcode}   ${textpostal}
    Sleep    1s
    Click                                      //*[@id='continue']


# This keyword Validates error handling on supplied User Information
Validate Incomplete User Information Error
    Click                                      //*[@id='continue']
    ${actual_error}=    Get Text                //*[@class='error-message-container error']
    FOR    ${expected_error}    IN    @{USERINFOCHECKOUTERROR}
        IF    '${actual_error}' == '${expected_error}'
            Element Should Be Visible           //*[@class='error-message-container error']
            Element Should Contain              //*[@class='error-message-container error']    ${expected_error}
            ${matched}=    Set Variable         ${True}
            User Logout
            Pass Execution                     Error Occurred: ${actual_error} Has Been Validated. Expected Error In Negative Tests
        END
    END
    IF    not ${matched}
        Fail                                   Error Flow Not Yet Covered. Please create a New Test Case for Uncovered Error Message
    END


# This keyword Completes the Checkout Process After User Information has been Supplied
Finish Checkout
    Wait For Elements State                     //*[@id='finish']    visible
    ${tax_text}=    Get Text                   //*[@class='summary_tax_label']
    ${tax}=    Evaluate                        float("${tax_text}".split('$')[1])
    Log    Total Tax Amount= ${tax}
    ${nettotal}=    Evaluate                   ${total} + ${tax}
    Log    Net Total= ${nettotal}
    ${summarytotal_text}=    Get Text          //*[@class='summary_total_label']
    ${summary_total}=    Evaluate              float("${summarytotal_text}".split('$')[1])
    Log    Summary Total= ${summary_total}
    Should Be Equal As Numbers                 ${nettotal}    ${summary_total}
    Click                                      //*[@id='finish']
    Wait For Elements State                    //*[@class='complete-header']    visible


# This keyword Validates existence of Checkout: User Information page elements
Validate User Information Page Elements
    Set Screenshot Directory                   ${SCREENSHOT_CHECKOUT_DIR}
    Open Cart
    Initiate Checkout
    @{userinfo_elem}=    Create List
    ...    //*[@id='first-name']
    ...    //*[@id='last-name']
    ...    //*[@id='postal-code']
    FOR    ${elem}    IN    @{userinfo_elem}
        Wait For Elements State                ${elem}    visible
        Element Should Be Enabled              ${elem}
        ${elemvalue}=    Get Property          ${elem}    value
        Should Be Empty                        ${elemvalue}
    END
    ${fname_label}=    Get Attribute           ${userinfo_elem}[0]    placeholder
    Should Be Equal                            ${fname_label}         First Name
    ${lname_label}=    Get Attribute           ${userinfo_elem}[1]    placeholder
    Should Be Equal                            ${lname_label}         Last Name
    ${zip_label}=    Get Attribute             ${userinfo_elem}[2]    placeholder
    Should Be Equal                            ${zip_label}           Zip/Postal Code
    Element Should Be Visible                  //*[@class='title']
    Element Text Should Be                     //*[@class='title']    Checkout: Your Information
    Element Should Be Visible                  //*[@id='cancel']
    Element Text Should Be                     //*[@id='cancel']    Cancel