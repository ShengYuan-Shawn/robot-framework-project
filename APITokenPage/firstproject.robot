*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# Declaring App URL
${AppURL}    https://app.deriv.com/account/api-token

# Login Variables
${inputEmail}    //input[@type='email']
${inputPassword}    //input[@type='password']
${submitButton}    //button[@type='submit']

# Loader
${accountLoader}    //*[@aria-label='Loading interface...']
${pageOverlay}    //div[@class='dc-page-overlay']

# Select Scope
${selectScope}    //div[@class='dc-timeline__content']
${selectRead}    //input[@name='read']//parent::label
${selectPayment}    //input[@name='payments']//parent::label
${selectAdmin}    //input[@name='admin']//parent::label
${selectTrade}    //input[@name='trade']//parent::label
${selectTradingInformation}    //input[@name='trading_information']//parent::label

# Checked Scope
${checkedRead}    //input[@name='read' and @value='true']//parent::label 
${checkedPayment}    //input[@name='payments' and @value='true']//parent::label 
${checkedAdmin}    //input[@name='admin' and @value='true']//parent::label 
${checkedTrade}    //input[@name='trade' and @value='true']//parent::label 
${checkedTradingInformation}    //input[@name='trading_information' and @value='true']//parent::label 

# Un-Checked Scope
${uncheckedRead}    //input[@name='read' and @value='false']//parent::label 
${uncheckedPayment}    //input[@name='payments' and @value='false']//parent::label 
${uncheckedAdmin}    //input[@name='admin' and @value='false']//parent::label 
${uncheckedTrade}    //input[@name='trade' and @value='false']//parent::label 
${uncheckedTradingInformation}    //input[@name='trading_information' and @value='false']//parent::label 

# Token Name Input Field
${inputTokenName}    //input[@name='token_name']

# Create Button Status
${createButtonStats}    //button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-btn__button-group da-api-token__button']

# Create Check Table Status
${checkTableStats}    //table[@class='da-api-token__table']
${tokenName}    //td[@class='da-api-token__table-cell da-api-token__table-cell--name']
${tokenLength}   //p[@class='dc-text']//parent::div//ancestor::td

# Copy Token
${copyIcon}    //*[@class='dc-icon dc-clipboard']
${adminPrompt}    //div[@class='dc-modal__container dc-modal__container--small dc-modal__container--enter-done']
${closeAdminnPrompt}    //button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button']
${tokenCopied}    //div[@class='dc-clipboard__popover dc-popover__bubble']

# Mask & Un-Masked
${maskedToken}    //div[@class='da-api-token__pass-dot-container']
${unmaskedToken}    //div[@class='da-api-token__clipboard-wrapper']
${maskedIcon}    //*[@class='dc-icon da-api-token__visibility-icon']
${hideTokenWidget}    //div[@id='chat-widget-container']

# Delete Token
${deleteButton}    //*[@class='dc-icon dc-clipboard da-api-token__delete-icon']
${deletePrompt}    //div[@class='dc-modal__container dc-modal__container--small dc-modal__container--enter-done']
${cancelButton}    //button[@class='dc-btn dc-btn__effect dc-btn--secondary dc-btn__large dc-dialog__button']
${yesDeleteButton}    //button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button']

# Validate Token Deleted
${tableRow}    //tr[@class='da-api-token__table-cell-row']

*** Keywords ***
Clear Input Field
    [Arguments]    @{inputField}
    Press Keys    ${inputField}    CTRL+a+BACKSPACE

*** Test Cases ***
Login To Deriv App
    Open Browser    ${AppURL}    Chrome
    Maximize Browser Window
    Sleep    1
    Wait Until Page Contains Element    ${inputEmail}    60
    Input Text    ${inputEmail}    email
    Input Text    ${inputPassword}    password
    Click Element    ${submitButton}

Wait API Token Page To Load
    Wait Until Page Does Not Contain Element    ${accountLoader}    60
    Wait Until Page Contains Element    ${pageOverlay}    60

Check And Un-Check Scope
    Wait Until Element Is Visible    ${selectScope}    60
    Wait Until Element Is Enabled    ${selectScope}    60
    Click Element    ${selectRead}
    Wait Until Page Contains Element    ${checkedRead}    60 
    Click Element    ${selectPayment}
    Wait Until Page Contains Element    ${checkedPayment}     60 
    Click Element    ${selectAdmin}
    Wait Until Page Contains Element    ${checkedAdmin}     60 
    Click Element    ${selectTrade}
    Wait Until Page Contains Element    ${checkedTrade}     60 
    Click Element    ${selectTradingInformation}
    Wait Until Page Contains Element    ${checkedTradingInformation}    60
    Sleep    1
    Click Element    ${selectRead}
    Wait Until Page Contains Element    ${uncheckedRead}    60 
    Click Element    ${selectPayment}
    Wait Until Page Contains Element    ${uncheckedPayment}     60 
    Click Element    ${selectAdmin}
    Wait Until Page Contains Element    ${uncheckedAdmin}     60 
    Click Element    ${selectTrade}
    Wait Until Page Contains Element    ${uncheckedTrade}     60 
    Click Element    ${selectTradingInformation}    
    Wait Until Page Contains Element    ${uncheckedTradingInformation}    60

Selecting API Token Scope
    Element Should Be Disabled    ${createButtonStats}
    Click Element    ${selectRead}
    Wait Until Page Contains Element    ${checkedRead}    60 
    Click Element    ${selectPayment}
    Wait Until Page Contains Element    ${checkedPayment}     60 
    Click Element    ${selectAdmin}
    Wait Until Page Contains Element    ${checkedAdmin}     60 
    Click Element    ${selectTrade}
    Wait Until Page Contains Element    ${checkedTrade}     60 
    Click Element    ${selectTradingInformation}
    Wait Until Page Contains Element    ${checkedTradingInformation}    60

Check Empty Input Field
    Click Element    ${inputTokenName}
    Element Should Be Disabled    ${createButtonStats}

Check Input Field Length & Types
    Click Element    ${inputTokenName}
    Input Text    ${inputTokenName}    a
    Element Should Be Disabled    ${createButtonStats}
    Click Element    ${inputTokenName}
    Clear Input Field    ${inputTokenName}
    
    Click Element    ${inputTokenName}
    Input Text    ${inputTokenName}    abcdefghijklmopqrstuvwxyz1234567890
    Element Should Be Disabled    ${createButtonStats}
    Click Element    ${inputTokenName}
    Clear Input Field    ${inputTokenName}

    Click Element    ${inputTokenName}
    Input Text    ${inputTokenName}    trying!my!best
    Element Should Be Disabled    ${createButtonStats}
    Click Element    ${inputTokenName}
    Clear Input Field    ${inputTokenName}
    
Check Verified Input Field
    Click Element    ${inputTokenName}
    Input Text    ${inputTokenName}    Test_Token_1
    ${getTokenName}=    Get Value    ${inputTokenName}
    Element Should Be Enabled    ${createButtonStats}    
    Wait Until Element Is Enabled    ${createButtonStats}    60
    Click Element    ${createButtonStats}

    Wait Until Page Contains Element    ${checkTableStats}    60
    Wait Until Element Is Visible    ${checkTableStats}    60
    
    Wait Until Page Contains Element    ${tokenName}    60
    Wait Until Element Is Visible    ${tokenName}    60
    ${verifyTokenName}=    Get Text    ${tokenName}
    Should Be Equal    ${verifyTokenName}    ${getTokenName}

Copy Token
    Wait Until Element Is Visible    ${copyIcon}    60
    Wait Until Element Is Enabled    ${copyIcon}    60
    Click Element    ${copyIcon}
    Wait Until Element Is Visible    ${adminPrompt}    60
    Wait Until Page Contains Element    ${adminPrompt}    60 
    Click Button    ${closeAdminnPrompt}
    Page Should Contain Element    ${tokenCopied}

Unmasked Token
    Wait Until Element Is Not Visible    ${tokenCopied}    60
    Wait Until Page Contains Element    ${maskedToken}
    Wait Until Element Is Enabled   ${maskedIcon} 
    Click Element    ${maskedIcon}
    Page Should Contain Element    ${unmaskedToken}
    Wait Until Page Contains Element    ${unmaskedToken}    60
    Wait Until Element Is Visible    ${unmaskedToken}    60
    ${verifyTokenLength}=    Get Text    ${tokenLength}
    Length Should Be    ${verifyTokenLength}   15
    Sleep    1
    Click Element    ${maskedIcon} 
 
Delete Token
    Wait Until Element Is Not Visible    ${hideTokenWidget}
    Page Should Contain Element    ${deleteButton}
    Click Element    ${deleteButton}
    Wait Until Page Contains Element    ${deletePrompt}    60
    Wait Until Element Is Visible    ${deletePrompt}    60
    Click Element    ${cancelButton}
    Wait Until Element Is Visible    ${deleteButton}
    Click Element    ${deleteButton}
    Wait Until Page Contains Element    ${deletePrompt}    60
    Wait Until Element Is Visible    ${deletePrompt}    60
    Click Element    ${yesDeleteButton}

Validate Token Has Been Deleted
    Wait Until Element Is Not Visible    ${tableRow}    60
    Element Should Not Be Visible    ${tableRow}