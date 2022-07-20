# 
# Author: Hector Rodriguez (hectorrrobles84@gmail.com)
# main.resource (c) 2022
# 
*** Settings ***
Documentation    This resource contains keywords common for all tests suites
Library    RequestsLibrary
Library    tools    WITH NAME    tools

*** Variables ***
${baseURL} =          https://api.spotify.com
${sessionName} =      httpSession


*** Keywords ***

Init session in Spotify API
    [Documentation]    Keyword to init session in Spotify API
    [Tags]    Keyword    login
    ${token} =    tools.getAccesToken    ${clientId}    ${clientSecret}
    &{headersData} =    Create Dictionary    Authorization    Bearer ${token}    Content-Type    application/json
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