*** Settings ***
Resource    ../elements/main_elements/main_elements.resource
Resource    main_actions/main_actions.robot


*** Keywords ***
Take a screenshot of the robot
    [Arguments]    ${order_Robot}
    Sleep    1.3s
    Screenshot    ${form.robot_preview}    ${OUTPUT_DIR}${/}robot_preview_screenshot_${order_Robot}.png
    [Return]    robot_preview_screenshot_${order_Robot}.png

