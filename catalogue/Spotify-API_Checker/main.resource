# 
# Author: Hector Rodriguez (hectorrrobles84@gmail.com)
# main.resource (c) 2022
# 
*** Settings ***
Documentation    This resource contains keywords and variables common for all tests suites
Library    RequestsLibrary
Library    tools    WITH NAME    tools

*** Variables ***
${baseURL} =          https://api.spotify.com
${sessionName} =      httpSession
${invalidToke} =      QQBhdS5S5EyKhQWuCGZPnBp-T6kh6xi3RErJMPlPBqmYycsXSuzBBAs4Zy0ryGjE2GppiSkMhHU1tttOi_wrfXTw7lVx5XHBSjBOWA75YLX4BGlMiOI

*** Keywords ***

Init session in Spotify API
    [Documentation]    Keyword to init session in Spotify API
    [Tags]    Keyword    login
    ${token} =    tools.getAccesToken    ${clientId}    ${clientSecret}
    ${passed} =    Run Keyword And Return Status    Variable Should Not Exist    ${authorizeToken}
    ${authorizeToken} =    Set Variable If    ${passed}    ${token}    ${authorizeToken}    
    &{headersData} =    Create Dictionary    Authorization    Bearer ${authorizeToken}    Content-Type    application/json
    &{jsonData} =    Create Dictionary    grant_type    client_credentials
    Create Session    ${sessionName}    ${baseURL}    verify=false    headers=${headersData}

End session in Spotify API
    [Documentation]    Keyword to init session in Spotify API
    [Tags]    Keyword    logout
    Delete All Sessions

Refresh session in Spotify API
    [Documentation]    Keyword to refresh session in Spotify API
    [Tags]    Keyword    refresh session
    Delete All Sessions
    Init session in Spotify API

The response code is the given code
    [Documentation]    Keywords to check if the reponse is the given code
    [Tags]    Keyword    artists
    [Arguments]    ${code}
    Should Contain    "${response}"    ${code}

Invalid token in session
    [Documentation]    Keywords to set invalid token in new session
    [Tags]    Keyword    artists
    Delete All Sessions    
    &{headersData} =    Create Dictionary    Authorization    Bearer ${invalidToke}    Content-Type    application/json
    &{jsonData} =    Create Dictionary    grant_type    client_credentials
    Create Session    ${sessionName}    ${baseURL}    verify=false    headers=${headersData}