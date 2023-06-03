*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.

Resource          resources/elements/main_elements/main_elements.resource
Resource          resources/actions/main_actions/main_actions.robot

*** Tasks ***
Order the robots from RobotSpareBin Industries Inc    
    Open the robot order website
#Download the order file
    Fill the form using the data from csv file

