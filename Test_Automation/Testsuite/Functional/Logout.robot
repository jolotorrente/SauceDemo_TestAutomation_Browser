*** Settings ***
Library         Browser

### Resource List of Resources ###
Resource        ../../Resources/Common_keywords.robot
Resource        ../../Resources/Login_keywords.robot
Resource        ../../Resources/Logout_keywords.robot

### Resource List of Variables ###
Resource        ../../Resources/Variables/Login_variables.robot
Resource        ../../Resources/Variables/Logout_variables.robot

### Documentation ###
Documentation   This test suite verifies the log-out functionality
...             This also Includes Security Testing by validating Secured Pages

### Keyword executed on start of each tests ###
Test Setup      Launch Website

### Keyword executed on start of each tests ###
Test Teardown   Close Browser


*** Test Cases ***

Logout 01 - Logout to Website After Successful Login
    [Tags]  High    Regression      Security    Smoke
    User Login                  ${USERNAME}             ${PASSWORD}
    User Logout

Logout 02 - Confirm Logout Session on Back Navigation
    [Tags]  High    Regression      Security
    User Login                  ${USERNAME}             ${PASSWORD}
    User Logout
    Confirm Logout Session on Back Navigation

Logout 03 - Confirm Logout Session after Refresh
    [Tags]  High    Regression      Security
    User Login                  ${USERNAME}             ${PASSWORD}
    User Logout
    Validate Successful Logout after Refresh

Logout 04 - Logged In Pages Not Accessible After Logout
    [Tags]  High    Regression      Security
    User Login                  ${USERNAME}             ${PASSWORD}
    User Logout
    Validate Secured Pages after Logout