*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# Declaring App URL
${AppURL}    https://app.deriv.com/account/closing-account

# Declaring Deriv URL
${HomeURL}    https://deriv.com/

# Login Variables
${inputEmail}    //input[@type='email']
${inputPassword}    //input[@type='password']
${submitButton}    //button[@type='submit']

# Loader
${accountLoader}    //*[@aria-label='Loading interface...']
${pageOverlay}    //div[@class='dc-page-overlay']
${pageContentOverlay}    //div[@class='dc-page-overlay__content']

# Check Settings Page
${tncDocuments}    //a[@class='link']
${cancelButton}    //button[@class='dc-btn dc-btn--secondary dc-btn__large closing-account__button--cancel']
${closeMyAccountButton}    //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']

# Select Check Case
@{closeAccReason}=    financial-priorities    stop-trading    not-interested    another-website    not-user-friendly    difficult-transactions    lack-of-features    unsatisfactory-service    other-reasons
${checkFinancialPriorities}    //input[@name='financial-priorities']//parent::label
${checkStopTrading}    //input[@name='stop-trading']//parent::label
${checkNotInterested}    //input[@name='not-interested']//parent::label
${checkAnotherWebsite}    //input[@name='another-website' and @disabled]
${checkNotUserFriendly}    //input[@name='not-user-friendly' and @disabled]
${checkDifficultTransactions}    //input[@name='difficult-transactions' and @disabled]
${checkLackFeatures}    //input[@name='lack-of-features' and @disabled]
${checkUnsatisfactory}    //input[@name='unsatisfactory-service' and @disabled]
${checkOtherReasons}    //input[@name='other-reasons' and @disabled]

# Check Reason Page
${closingAccountError}    //p[@class='dc-text closing-account-reasons__error']
${backButton}    //div[@class='closing-account-reasons__footer']//button[@class='dc-btn dc-btn__effect dc-btn--secondary dc-btn__large']
${continueButton}    //div[@class='closing-account-reasons__footer']//button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large']
${inputFieldOtherTradingPlatform}    //textarea[@name='other_trading_platforms']
${inputFieldDoToImprove}    //textarea[@name='do_to_improve']

# Close Account Prompt
${closeAccountPrompt}    //div[@class='dc-modal']
${returnButton}    //div[@class='dc-modal']//button[@class='dc-btn dc-btn__effect dc-btn--secondary dc-btn__large']
${closeAccountButton}    //div[@class='dc-modal']//button[@class='dc-btn dc-btn__effect dc-btn--primary dc-btn__large']

# Verify Close Account Message
${closeAccountMessage}    //div[@class='dc-modal__container undefined dc-modal__container--enter-done']

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

Wait Settings Page To Load
    Wait Until Page Does Not Contain Element    ${accountLoader}    60
    Wait Until Page Contains Element    ${pageOverlay}    60

Check Confirmation Page
    Wait Until Page Contains Element    ${pageContentOverlay}    60
    Page Should Contain Link    ${tncDocuments}
    Wait Until Element Is Visible    ${cancelButton}    60
    Wait Until Element Is Enabled    ${cancelButton}    60
    Wait Until Element Is Visible    ${closeMyAccountButton}    60
    Wait Until Element Is Enabled    ${closeMyAccountButton}    60
    Click Element    ${closeMyAccountButton}

Back To Confirmation Page
    Wait Until Page Does Not Contain Element    ${accountLoader}    60
    Wait Until Page Contains Element    ${pageContentOverlay}    60
    Wait Until Element Is Visible    ${pageContentOverlay}    60
    Element Should Be Enabled    ${backButton}
    Click Element    ${backButton}

Go To Close My Account Page
    Wait Until Page Contains Element    ${pageContentOverlay}    60
    Page Should Contain Link    ${tncDocuments}
    Wait Until Element Is Visible    ${cancelButton}    60
    Wait Until Element Is Enabled    ${cancelButton}    60
    Wait Until Element Is Visible    ${closeMyAccountButton}    60
    Wait Until Element Is Enabled    ${closeMyAccountButton}    60
    Click Element    ${closeMyAccountButton}
    
Verify Close My Account Page
    Wait Until Page Contains Element    ${pageContentOverlay}    60
    Wait Until Element Is Visible    ${pageContentOverlay}    60
    Element Should Be Enabled    ${backButton}
    Element Should Be Disabled    ${continueButton}
    # For Loop to Verify the Checkbox
    FOR  ${reason}  IN  @{closeAccReason}
        Click Element    //input[@name='${reason}']//parent::label
        Wait Until Page Contains Element    //input[@name='${reason}' and @value='true']//parent::label
        Checkbox Should Be Selected    //input[@name='${reason}']
        Click Element    //input[@name='${reason}']//parent::label 
        Element Should Be Visible    ${closingAccountError}
        Wait Until Page Contains Element    //input[@name='${reason}' and @value='false']//parent::label
        Checkbox Should Not Be Selected    //input[@name='${reason}']
    END

Verify Reason Is Required
    Wait Until Element Is Enabled    ${pageContentOverlay}    60
    Click Element    ${checkFinancialPriorities}
    Element Should Not Be Visible    ${closingAccountError}
    Element Should Be Enabled    ${continueButton}
    Click Element    ${checkFinancialPriorities}
    Element Should Be Visible    ${closingAccountError}

Check The Reasons
    Click Element    ${checkFinancialPriorities}
    Click Element    ${checkNotInterested}
    Click Element    ${checkStopTrading}
    Element Should Be Disabled    ${checkAnotherWebsite}
    Element Should Be Disabled    ${checkNotUserFriendly}
    Element Should Be Disabled    ${checkLackFeatures}
    Element Should Be Disabled    ${checkUnsatisfactory}
    Element Should Be Disabled    ${checkAnotherWebsite}
    Element Should Be Disabled    ${checkOtherReasons} 
    Element Should Be Enabled    ${continueButton}

Verify Input Field Types & Character Length
    # Verify Symbol Is Not Allowed
    Element Should Not Be Visible    ${closingAccountError}
    Click Element    ${inputFieldOtherTradingPlatform}
    Input Text    ${inputFieldOtherTradingPlatform}    @sdflsa;jldkjfa;lksdjf1234
    Element Should Be Disabled    ${continueButton}
    Element Should Be Visible    ${closingAccountError}
    Click Element    ${inputFieldOtherTradingPlatform}
    Clear Input Field    ${inputFieldOtherTradingPlatform}
    
    Click Element    ${inputFieldOtherTradingPlatform}
    Input Text    ${inputFieldOtherTradingPlatform}    There is some other platform have more features. There is some other platform have more features.
    Click Element    ${inputFieldDoToImprove}
    Input Text    ${inputFieldDoToImprove}    Usability can be improve maybe. Just a dummy sentence.

Clear Text Input Field
    Click Element    ${inputFieldOtherTradingPlatform}
    Clear Input Field    ${inputFieldOtherTradingPlatform}
    Click Element    ${inputFieldDoToImprove}
    Clear Input Field    ${inputFieldDoToImprove}
    
Typing Text In Input Field
    Click Element    ${inputFieldOtherTradingPlatform}
    Input Text    ${inputFieldOtherTradingPlatform}    XXXX platform have more features and is better. There is some other platform have more features.
    Element Should Not Contain    ${inputFieldOtherTradingPlatform}    If you don’t mind sharing, which other trading platforms do you use?

    Click Element    ${inputFieldDoToImprove}
    Input Text    ${inputFieldDoToImprove}    Usability can be improve maybe. Just a dummy sentence.
    Element Should Not Contain    ${inputFieldDoToImprove}    What could we do to improve?

# Continue To Close Account
#     Click Element    ${continueButton}
#     Wait Until Page Contains Element    ${closeAccountPrompt}    60
#     Wait Until Element Is Visible    ${closeAccountPrompt}    60
#     Wait Until Element Is Visible    ${returnButton}    60
#     Wait Until Element Is Visible    ${closeAccountButton}    60

#     Click Element    ${returnButton}
#     Wait Until Element Is Enabled    ${pageContentOverlay}    60

#     Click Element    ${continueButton}
#     Wait Until Page Contains Element    ${closeAccountPrompt}    60
#     Wait Until Element Is Visible    ${closeAccountPrompt}
#     Wait Until Element Is Visible    ${returnButton}
#     Wait Until Element Is Visible    ${closeAccountButton}
#     Click Element    ${closeAccountButton}

# Verify Close Account
#     Wait Until Page Contains Element    ${closeAccountMessage}    60
#     Wait Until Element Is Visible    ${closeAccountMessage}    60
#     Sleep    20

# Verify Final Location
#     Location Should Be    ${HomeURL}