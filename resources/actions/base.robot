*** Settings ***
Resource    ../elements/main_elements/main_elements.resource
Resource    main_actions/main_actions.robot

Library     RPA.Browser.Selenium    #auto_close=${False}
Library     RPA.HTTP

*** Variables ***
${ordersFile}             https://robotsparebinindustries.com/orders.csv     
${PDF_TEMP_OUTPUT_DIRECTORY}=       ${CURDIR}${/}temp
${ordersPath}             orders.csv

*** Keywords ***
Open the robot order website
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
    Maximize Browser Window
    Close the annoying modal

Close the annoying modal
    Click Button When Visible    ${form.modal}

Download the order file
    Download    ${ordersFile}  

Set up directories
    Create Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}
    Create Directory    ${OUTPUT_DIR}