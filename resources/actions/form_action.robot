*** Settings ***
Documentation    aqui estão as keywords relacionadas ao preenchimento do formulario
Library           RPA.Browser.Selenium    #auto_close=${False}
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.Tables
Library           OperatingSystem
Library           RPA.PDF
Library           RPA.Desktop
Library           RPA.Archive

Resource         ../elements/main_elements/main_elements.resource
Resource        ../actions/main_actions/main_actions.robot

*** Keywords ***
Fill the form using the data from csv file
    Set up directories
    ${orders}=       Read table from CSV    ${ordersPath}    header=${True}
    FOR    ${order_Robot}    IN    @{orders}
        Fill the form for one order   ${order_Robot}
        Click Button                 ${form.button_preview} 
        ${screenshot}=    Take a screenshot of the robot    ${order_Robot}[Order number]
        Submit order
        ${pdf}=    Store the order result as a pdf file    ${order_Robot}[Order number]
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}     ${order_Robot}[Order number]
        Wait Until Element Is Visible    ${receipt.button_order_another}  5s
        Click Button        ${receipt.button_order_another} 
        Wait Until Element Is Visible        //button[@class='btn btn-danger']
        Close the annoying modal
    END     
    Create a ZIP file of receipt PDF files 
    [Teardown]    Cleanup temporary PDF directory 

Fill the form for one order
    [Arguments]                  ${order_Robot}
    Select From List By Index    ${form.select_head}                           ${order_Robot}[Head]
    Select Radio Button          ${form.radio_button}          ${order_Robot}[Body]
    Input Text                   ${form.input_text_legs}       ${order_Robot}[Legs]
    Input Text                   ${form.input_text_address}    ${order_Robot}[Address]

Submit order
    Run Keyword And Continue On Failure    
    ...    Run Keyword And Ignore Error    Click Button    ${form.button_submit}
    ${condition}=     Run Keyword And Return Status   Element Should Not Be Visible    ${form.button_submit}
    Wait Until Keyword Succeeds    5x    0.5   Run Keyword If    ${condition} == ${False}    Click Button    ${form.button_submit}  
