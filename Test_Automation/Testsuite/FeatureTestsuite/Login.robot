*** Settings ***
Library         Browser

### Resource List of Keywords ###
Resource        ../../Keywords/Common_keywords.robot
Resource        ../../Keywords/Login_keywords.robot

### Resource List of Variables ###
Resource        ../../Variables/Login_variables.robot

### Documentation ###
Documentation   This test suite verifies the log-in functionality

### Keyword executed on start of each tests ###
Test Setup      Launch Website

### Keyword executed on start of each tests ###
Test Teardown   Close Browser


*** Test Cases ***

Login 01 - Login using valid Username and Password
    [Tags]  High    Smoke
    User Login                  ${USERNAME}         ${PASSWORD}
    User Logout

Login 02 - Negative Test: Login using valid Username Invalid Password
    [Tags]  High    Smoke
    User Failed Login           ${USERNAME}         ${INVALIDPASSWORD}

Login 03 - Negative Test: Login using Locked Out User
    [Tags]  Medium
    User Failed Login           ${LOCKED_USERNAME}  ${PASSWORD}

Login 04 - Negative Test: Login using Empty or Null Username
    [Tags]  Low
    User Failed Login           ${NULL}             ${PASSWORD}

Login 05 - Negative Test: Login using Empty or Null Password
    [Tags]  Low
    User Failed Login           ${USERNAME}         ${NULL}

Login 06 - Login Credentials should allow alphanumeric and special characters
    [Tags]  Low
    Validate Input Fields       @{INPUT_VALIDATION}

Login 07 - Validate Login Page Elements
    [Tags]  Low     Smoke
    Validate Login Page Elements