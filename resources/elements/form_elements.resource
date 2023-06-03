*** Settings ***
Documentation    aqui estão os elementos web do formulario

*** Variables ***
&{form}    
...        button_preview=preview
...        select_head=head
...        radio_button=body
...        input_text_legs=//input[contains(@type,'number')]
...        input_text_address=address
...        button_submit=order
...        modal=//button[@class='btn btn-danger']
...        robot_preview=robot-preview-image