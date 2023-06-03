*** Settings ***
Resource    ../elements/main_elements/main_elements.resource
Resource    main_actions/main_actions.robot


*** Keywords ***
Create a ZIP file of receipt PDF files
    ${zip_file}=    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip
    ...    ${PDF_TEMP_OUTPUT_DIRECTORY}
    ...    ${zip_file}

Cleanup temporary PDF directory
    Remove Directory    ${PDF_TEMP_OUTPUT_DIRECTORY}    True