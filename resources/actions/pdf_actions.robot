*** Settings ***
Resource    ../elements/main_elements/main_elements.resource
Resource    main_actions/main_actions.robot


*** Keywords ***
Store the order result as a pdf file
    [Arguments]                                  ${order_Robot}
    Wait Until Element Is Visible                ${receipt.div_receipt}
    ${receipt_HTML}=    Get Element Attribute    ${receipt.div_receipt}    outerHTML
    Html To Pdf    ${receipt_HTML}   ${PDF_TEMP_OUTPUT_DIRECTORY}/order_receipt_${order_Robot}.pdf
    [Return]       order_receipt_${order_Robot}.pdf  

Embed the robot screenshot to the receipt PDF file 
    [Arguments]    ${pdf}    ${screenshot}    ${order_Robot}
    Open Pdf    ${OUTPUT_DIR}${/}${pdf}
    @{files}    Create List
    ...     ${OUTPUT_DIR}${/}robot_preview_screenshot_${order_Robot}.png:align=center, format=Letter
    Add Files To Pdf        ${files}    ${PDF_TEMP_OUTPUT_DIRECTORY}/order_receipt_${order_Robot}.pdf    ${PDF_TEMP_OUTPUT_DIRECTORY}/order_receipt_${order_Robot}.pdf            
    Close All Pdfs