*** Variables ***
#############################
#Variables User Information for Checkout: Your Information page
@{FIRST_NAME}                   Leni    Bam    Rodrigo    Bongbong    Raffy
@{LAST_NAME}                    Robredo    Aquino    Duterte    Marcos    Tulfo
@{POSTAL_CODE}                  1900    1800    1905    1795    1995
@{MY_LIST}                      ${EMPTY}    ${EMPTY}

#List Variables for User Information errors
@{USERINFOCHECKOUTERROR}
...    Error: First Name is required
...    Error: Last Name is required
...    Error: Postal Code is required