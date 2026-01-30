*** Settings ***
Library         Browser

### Resource List of Resources ###
Resource        ../../Resources/Common_keywords.robot
Resource        ../../Resources/Login_keywords.robot
Resource        ../../Resources/Inventory_keywords.robot
Resource        ../../Resources/Checkout_keywords.robot

### Resource List of Variables ###
Resource        ../../Resources/Variables/Login_variables.robot
Resource        ../../Resources/Variables/Checkout_variables.robot

### Documentation ###
Documentation   This test suite verifies multiple functionalities combined resulting to End-to-End Scenarios
...             This also covers End-User Use Cases, How the Application is used by End-Users

### Keyword executed on start of each tests ###
Test Setup      Launch Website

### Keyword executed on start of each tests ###
Test Teardown   Close Browser


*** Test Cases ***

End-to-End_Regression 01 - User to Purchase Products added to Cart
    [Tags]  High    Regression
    User Login                  ${USERNAME}         ${PASSWORD}
    Add Random Product to Cart
    Checkout Cart               ${FIRST_NAME}       ${LAST_NAME}        ${POSTAL_CODE}
    User Logout

End-to-End_Regression 02 - User to Remove Products prior to Checkout and Payment
    [Tags]  High    Regression
    User Login                  ${USERNAME}         ${PASSWORD}
    Add Random Product to Cart
    Checkout Cart               ${FIRST_NAME}       ${LAST_NAME}        ${POSTAL_CODE}
    User Logout

End-to-End_Regression 03 - Retain Products added to Cart after Logout when User did not complete Checkout
    [Tags]  High    Regression
    User Login                  ${USERNAME}             ${PASSWORD}
    Add Random Product to Cart
    Open Cart
    Initiate Checkout
    Supply User Information  ${firstname}    ${lastname}    ${postalcode}
    User Logout
    User Login                  ${USERNAME}             ${PASSWORD}
    Validate Cart Badge
    User Logout