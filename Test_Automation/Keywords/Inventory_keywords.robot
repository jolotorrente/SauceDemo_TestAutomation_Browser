*** Settings ***
Library         Browser
Library         String
Library         Collections

### Resource List of Keywords ###
Resource        ../Keywords/Global_keywords.robot

### Resource List of Variables ###
Resource        ../Variables/Login_variables.robot
Resource        ../Variables/Inventory_variables.robot

### Documentation ###
Documentation   This Keyword Robot File is a compilation Inventory functionalities
...             Add and Remove Products
...             Cart Interactions
...             Product View
...             Product Sort (WIP)

*** Keywords ***
###################################################
##  Inventory / Shopping Page Component Keywords ##
###################################################



# This keyword Asserts the Inventory Page Elements
Validate Inventory Page Elements
    Wait For Elements State                         //*[@class='app_logo']      visible
    Get Text                                        //*[@class='app_logo']    ==    Swag Labs
    Wait For Elements State                         id=shopping_cart_container  visible
    Get Element States                              id=shopping_cart_container  contains    enabled
    Wait For Elements State                         id=react-burger-menu-btn    visible
    Get Element States                              id=react-burger-menu-btn    contains    enabled
    Wait For Elements State                         //*[@class='title']    visible
    Get Text                                        //*[@class='title']    ==    Products
    Wait For Elements State                         //*[@class='product_sort_container']    visible
    Get Element States                              //*[@class='product_sort_container']    contains    enabled
    Wait For Elements State                         //*[@class='inventory_list']    visible


# This keyword Asserts Product Elements on Product View
Validate Product Elements on Product View
    ${productcount}=    Get Element Count            //*[@class='inventory_item']//*[@class='inventory_item_name ']
    FOR    ${i}    IN RANGE    ${productcount}
        ${index}=    Evaluate    ${i} + 1
        Wait For Elements State                     //*[@class='inventory_item'][${index}]//*[@class='inventory_item_img']    visible
        ${productname}=    Get Text                 //*[@class='inventory_item'][${index}]//*[@class='inventory_item_description']//*[@class='inventory_item_name ']
        Click                                       //*[@class='inventory_item'][${index}]//*[@class='inventory_item_img']
        Wait For Elements State                     id=back-to-products    visible
        Wait For Elements State                     //*[@class='inventory_details_img_container']    visible
        Take Screenshot                             Listed-Product-${index}.png
        Click                                       id=back-to-products
    END


# This keyword Returns the total number of products currently displayed on the inventory page
Get Inventory Product Count
    Wait For Elements State                         //*[@class='inventory_item'][1]    visible
    ${productcounter}=    Get Element Count          //*[@class='inventory_item']
    RETURN    ${productcounter}


# This keyword Returns a random number of products to add, based on the total number of products
Generate Random Quantity
    [Arguments]    ${total_products}
    ${rdmquantity}=    Evaluate    random.randint(1, ${total_products})    random
    Set Test Variable    ${rdmquantity}
    RETURN    ${rdmquantity}


# This keyword Returns a list of unique random indexes for selecting products
Generate Random Indexes
    [Arguments]    ${total_products}    ${quantity}
    ${all_indexes}=     Evaluate    list(range(1, ${total_products}+1))
    ${random_indexes}=  Evaluate    random.sample(${all_indexes}, ${quantity})    random
    Set Test Variable   ${random_indexes}
    RETURN    ${random_indexes}


# This keyword Returns a random index for cart items
Generate Random Cart Index
    [Arguments]    ${total_in_cart}
    ${all_indexes}=     Evaluate    list(range(1, ${total_in_cart}+1))
    ${random_index}=    Evaluate    random.choice(${all_indexes})    random
    RETURN    ${random_index}


# This keyword Returns the total number of products currently in the cart
Get Cart Product Count
    Wait For Elements State                         (//*[@class='cart_list']//*[text()='Remove'])[1]    visible
    ${cart_count}=    Get Element Count             //*[@class='cart_list']//*[text()='Remove']
    RETURN    ${cart_count}


# This keyword Adds Random Product/s to Cart
Add Random Product to Cart
    ${productcounter}=    Get Inventory Product Count
    ${rdmquantity}=       Generate Random Quantity    ${productcounter}
    Set Test Variable     ${rdmquantity}
    ${random_indexes}=    Generate Random Indexes     ${productcounter}    ${rdmquantity}
    FOR    ${index}    IN    @{random_indexes}
        Click And Validate Product    ${index}
    END
    Validate Cart Badge


# Clicks the Add to Cart button for a specific product index and validates it in the cart
Click And Validate Product
    [Arguments]    ${index}
    ${add_btn}=      Set Variable                   //*[@class='inventory_item'][${index}]//*[text()='Add to cart']
    ${productname}=  Get Text                       //*[@class='inventory_item'][${index}]//*[@class='inventory_item_description']//*[@class='inventory_item_name ']
    # Browser Library automatically scrolls; Scroll To is kept for manual preference
    Scroll To                                       ${add_btn}
    Wait For Elements State                         ${add_btn}    visible
    Click                                           ${add_btn}
    Open Cart
    Wait For Elements State                         //*[@class='title' and text()='Your Cart']    visible
    Wait For Elements State                         //*[@class='inventory_item_name' and text()='${productname}']    visible
    Take Screenshot                                 Product-${productname}_Added_to_Cart.png
    Return to Shopping


# This keyword Removes Random Product/s from the Shopping Cart
Remove Random Product from Shopping Cart
    Open Cart
    ${cart_count}=    Get Cart Product Count
    ${random_index}=  Generate Random Cart Index     ${cart_count}
    Click And Validate Removal                      ${random_index}


# This keyword Removes ALL Product/s from the Shopping Cart safely
Remove All Products from Shopping Cart
    Open Cart
    ${cart_count}=    Get Cart Product Count
    IF    ${cart_count} > 0
        FOR    ${index}    IN RANGE    ${cart_count}
            Click And Validate Removal    1
            Open Cart
        END
    ELSE
        Log    Cart is already empty, nothing to remove
    END
    Validate Shopping Cart Default State


# This keyword Clicks the Remove button for a specific cart item index and validates removal
Click And Validate Removal
    [Arguments]    ${index}
    ${remove_btn}=    Set Variable                  //*[@class='cart_list']//*[@class='cart_item'][${index}]//*[text()='Remove']
    ${productname}=   Get Text                      //*[@class='cart_list']//*[@class='cart_item'][${index}]//*[@class='inventory_item_name']
    Scroll To                                       ${remove_btn}
    Wait For Elements State                         ${remove_btn}    visible
    Click                                           ${remove_btn}
    Wait For Elements State                         //*[@class='title' and text()='Your Cart']    visible
    Wait For Elements State                         //*[@class='inventory_item_name' and text()='${productname}']    detached
    Reload
    Wait For Elements State                         //*[@class='title' and text()='Your Cart']    visible
    Wait For Elements State                         //*[@class='inventory_item_name' and text()='${productname}']    detached
    Return to Shopping
    Wait For Elements State                         //*[@class='inventory_item' and .//div[text()='${productname}']]    visible
    Wait For Elements State                         //*[@class='inventory_item' and .//div[text()='${productname}']]//button[text()='Add to cart']    visible
    Take Screenshot                                 Product-${productname}_Removed_and_Inventory_Checked.png
    Set Test Message                                ${productname} was removed from the cart    append=yes


# This keyword Removes Random Product/s from Inventory page and validates Shopping Cart
Remove Random Product from Shopping Page
    Wait For Elements State                         //*[@class='inventory_item'][1]    visible
    ${total_products}=    Get Element Count          //*[@class='inventory_item']
    @{products_with_remove}=    Create List
    @{remove_btns}=              Create List
    @{add_btns}=                 Create List
    FOR    ${index}    IN RANGE    1    ${total_products + 1}
        ${has_removebtn}=    Run Keyword And Return Status
        ...    Wait For Elements State               //*[@class='inventory_item'][${index}]//button[text()='Remove']    visible    timeout=1s
        IF    ${has_removebtn}
            ${product_name}=    Get Text             //*[@class='inventory_item'][${index}]//*[@class='inventory_item_name ']
            Append To List      ${products_with_remove}    ${product_name}
            ${remove_btn}=      Set Variable         //*[@class='inventory_item'][${index}]//*[text()='Remove']
            Append To List      ${remove_btns}       ${remove_btn}
            ${add_btn}=         Set Variable         //*[@class='inventory_item'][${index}]//*[text()='Add to cart']
            Append To List      ${add_btns}          ${add_btn}
        END
    END
    ${rand_index}=    Evaluate                       random.randint(0, len(${products_with_remove}) - 1)    random
    ${selected_product}=      Set Variable           ${products_with_remove}[${rand_index}]
    ${selected_remove_btn}=   Set Variable           ${remove_btns}[${rand_index}]
    ${selected_add_btn}=      Set Variable           ${add_btns}[${rand_index}]
    Wait For Elements State                         ${selected_remove_btn}    visible
    Click                                           ${selected_remove_btn}
    Wait For Elements State                         ${selected_add_btn}       visible
    Open Cart
    Wait For Elements State                         //*[@class='title' and text()='Your Cart']    visible
    Wait For Elements State                         //*[@class='inventory_item_name' and text()='${selected_product}']    detached
    Set Test Message                                ${selected_product} was removed from the cart    append=yes



# This keyword Validates Cart Quantity
Validate Cart Badge
    Wait For Elements State                         //*[@class='shopping_cart_link']    visible
    ${cartstatus}=    Run Keyword And Return Status
    ...    Wait For Elements State                  //*[@class='shopping_cart_badge']    visible    timeout=1s
    IF    ${cartstatus}
        ${cartcounter}=    Get Text                 //*[@class='shopping_cart_badge']
        Should Be Equal As Integers                 ${cartcounter}    ${rdmquantity}
    ELSE
        Validate Shopping Cart Default State
    END


# This keyword Asserts the Shopping Cart Quantity Elements
Validate Shopping Cart Default State
    Open Cart
    Wait For Elements State                         //*[@class='bm-burger-button']    visible
    Wait For Elements State                         //*[@class='title' and text()='Your Cart']    visible
    Get Text                                        //*[@class='title' and text()='Your Cart']    ==    Your Cart
    Wait For Elements State                         //*[@class='cart_quantity_label']    visible
    Get Text                                        //*[@class='cart_quantity_label']    ==    QTY
    Wait For Elements State                         //*[@class='cart_desc_label']    visible
    Get Text                                        //*[@class='cart_desc_label']    ==    Description
    Wait For Elements State                         //*[@id='continue-shopping']    visible
    Get Element States                              //*[@id='continue-shopping']    contains    enabled
    Get Text                                        //*[@id='continue-shopping']    ==    Continue Shopping
    Wait For Elements State                         //*[@id='checkout']    visible
    Get Element States                              //*[@id='checkout']    contains    enabled
    Get Text                                        //*[@id='checkout']    ==    Checkout