*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library           RPA.Browser.Selenium    #auto_close=${False}
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.Tables
Library           OperatingSystem
Library           RPA.PDF
Library           RPA.Desktop
Library           RPA.Archive
    
*** Variables ***
${ordersFile}             https://robotsparebinindustries.com/orders.csv     
${ordersPath}             orders.csv
${PDF_TEMP_OUTPUT_DIRECTORY}=       ${CURDIR}${/}temp

*** Tasks ***
Order the robots from RobotSpareBin Industries Inc    
    Open the robot order website
#Download the order file
    Fill the form using the data from csv file

*** Keywords ***
Open the robot order website
    Open Available Browser     url=https://robotsparebinindustries.com/#/robot-order
    Maximize Browser Window
    Close the annoying modal

Close the annoying modal
    Click Button When Visible    //button[@class='btn btn-danger']

Download the order file
    Download    ${ordersFile}    #overwrite=${True}

Fill the form using the data from csv file
    Set up directories
    ${orders}=       Read table from CSV    ${ordersPath}    header=${True}
    FOR    ${order_Robot}    IN    @{orders}
        Fill the form for one order   ${order_Robot}
        Click Button                 preview 
        ${screenshot}=    Take a screenshot of the robot    ${order_Robot}[Order number]
        Submit order
        ${pdf}=    Store the order result as a pdf file    ${order_Robot}[Order number]
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}     ${order_Robot}[Order number]
        Wait Until Element Is Visible    order-another  5s
        Click Button        order-another
        Wait Until Element Is Visible        //button[@class='btn btn-danger']
        Close the annoying modal
    END     
    Create a ZIP file of receipt PDF files

Fill the form for one order
    [Arguments]                  ${order_Robot}
    Select From List By Index    head                           ${order_Robot}[Head]
    Scroll Element Into View     //label[contains(@for,'id-body-6')]
    Select Radio Button          body    ${order_Robot}[Body]
    Input Text                   //input[contains(@type,'number')]   ${order_Robot}[Legs]
    Input Text                   address    ${order_Robot}[Address]

Submit order
    Run Keyword And Continue On Failure    
    ...    Run Keyword And Ignore Error    Click Button    order
    ${condition}=     Run Keyword And Return Status   Element Should Not Be Visible    order
    Wait Until Keyword Succeeds    5x    0.5   Run Keyword If    ${condition} == ${False}    Click Button    order  

Store the order result as a pdf file
    [Arguments]    ${order_Robot}
    Wait Until Element Is Visible    receipt
    ${receipt_HTML}=    Get Element Attribute    receipt    outerHTML
    Html To Pdf    ${receipt_HTML}   ${PDF_TEMP_OUTPUT_DIRECTORY}/order_receipt_${order_Robot}.pdf
    [Return]       order_receipt_${order_Robot}.pdf  

Take a screenshot of the robot
    [Arguments]    ${order_Robot}
    Sleep    1.3s
    Screenshot    robot-preview-image    ${OUTPUT_DIR}${/}robot_preview_screenshot_${order_Robot}.png
    [Return]    robot_preview_screenshot_${order_Robot}.png

Embed the robot screenshot to the receipt PDF file 
    [Arguments]    ${pdf}    ${screenshot}    ${order_Robot}
    Open Pdf    ${OUTPUT_DIR}${/}${pdf}
    @{files}    Create List
    ...     ${OUTPUT_DIR}${/}robot_preview_screenshot_${order_Robot}.png:align=center, format=Letter
    Add Files To Pdf        ${files}    ${PDF_TEMP_OUTPUT_DIRECTORY}/order_receipt_${order_Robot}.pdf    ${PDF_TEMP_OUTPUT_DIRECTORY}/order_receipt_${order_Robot}.pdf            
    Close All Pdfs

Set up directories
    Create Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}
    Create Directory    ${OUTPUT_DIR}

Create a ZIP file of receipt PDF files
    ${zip_file}=    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip
    ...    ${PDF_TEMP_OUTPUT_DIRECTORY}
    ...    ${zip_file}

Cleanup temporary PDF directory
    Remove Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}    True