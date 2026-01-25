*** Settings ***
Library         Browser

### Resource List of Keywords ###
Resource        ../../Keywords/Login_keywords.robot
Resource        ../../Keywords/Inventory_keywords.robot

### Resource List of Variables ###
Resource        ../../Variables/Login_variables.robot

### Documentation ###
Documentation   This test suite verifies the Add and Remove of Products to Shopping Cart functionality
...             This also includes assertion of Elements within the Inventory Page

### Keyword executed on start of each tests ###
Test Setup      Launch Website

### Keyword executed on start of each tests ###
Test Teardown   Close Browser


*** Test Cases ***

Inventory 01 - Validate Product Inventory Page Elements
    [Tags]  Low    Smoke
    User Login                  ${USERNAME}             ${PASSWORD}
    Validate Inventory Page Elements
    User Logout

Inventory 02 - Add Product to Shopping Cart from the Shopping Page
    [Tags]  Medium
    User Login                  ${USERNAME}             ${PASSWORD}
    Add Random Product to Cart
    User Logout

Inventory 03 - Add Product from the Shopping Page and Remove Product from the Shopping Cart
    [Tags]  Medium
    User Login                  ${USERNAME}             ${PASSWORD}
    Add Random Product to Cart
    Remove Random Product from Shopping Cart
    User Logout

Inventory 04 - Add and Remove Product to Shopping Cart from the Shopping Page
    [Tags]  High
    User Login                  ${USERNAME}             ${PASSWORD}
    Add Random Product to Cart
    Remove Random Product from Shopping Page
    User Logout

Inventory 05 - Negative Test: Navigate to a Non-Existing Product Page
    [Tags]  Medium  Security
    User Login                  ${USERNAME}             ${PASSWORD}
    User Logout

Inventory 06 - Validate Cart Default State
    [Tags]  Low     Smoke
    User Login                  ${USERNAME}             ${PASSWORD}
    Validate Cart Badge
    User Logout

Inventory 07 - Empty the Cart (Remove All Products to Cart)
    [Tags]  Medium
    User Login                  ${USERNAME}             ${PASSWORD}
    Add Random Product to Cart
    Remove All Products from Shopping Cart
    User Logout

Inventory 08 - Navigate Back to Shopping from Cart
    [Tags]  Medium
    User Login                  ${USERNAME}             ${PASSWORD}
    Add Random Product to Cart
    Open Cart
    Return to Shopping
    User Logout