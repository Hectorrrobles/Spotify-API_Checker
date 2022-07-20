# 
# Author: Hector Rodriguez (hectorrrobles84@gmail.com)
# 01__GET.robot (c) 2022
# 
*** Settings ***
Force Tags        Spotify API    GET
Resource          ../main.resource
Suite Setup       Init session in Spotify API
Suite Teardown    End session in Spotify API

*** Variables ***
${validArtistId} =      6XyY86QOPPrYVGvF9ch6wz
${validArtistName} =    Linkin Park
${invalidArtistId} =    6XyY86QOPPrYVGvF9ch6ws
${invalidToke} =        QQBhdS5S5EyKhQWuCGZPnBp-T6kh6xi3RErJMPlPBqmYycsXSuzBBAs4Zy0ryGjE2GppiSkMhHU1tttOi_wrfXTw7lVx5XHBSjBOWA75YLX4BGlMiOI

*** Keywords ***
Init URL to get an artist
    [Documentation]    Keywords to generate the URL to get the artist data with given ID
    [Tags]    Keyword    artists
    [Arguments]    ${givenId}
    ${artistURL} =    Catenate    SEPARATOR=/    ${baseURL}    v1    artists    ${givenId}
    Set Test Variable    ${artistURL}

Use get an artist request
    [Documentation]    Keywords to make a request to get artist data with the given URL
    [Tags]    Keyword    artists
    [Arguments]    ${givenURL}
    ${response} =    GET On Session    ${sessionName}    ${givenURL}    expected_status=any
    Set Test Variable    ${response}

The response code is the given code
    [Documentation]    Keywords to check if the reponse is the given code
    [Tags]    Keyword    artists
    [Arguments]    ${code}
    Should Contain    "${response}"    ${code}


The response json is not empty
    [Documentation]    Keywords to check if the json is not empty
    [Tags]    Keyword    artists
    Should Not Be Equal As Strings    []    ${response.json()}


The response json has the given name
    [Documentation]    Keywords to check if the json has the given name
    [Tags]    Keyword    artists
    [Arguments]    ${givenName}
    Should Contain    "${response.json()}[name]"    ${givenName}

Invalid token in session
    [Documentation]    Keywords to set invalid token in new session
    [Tags]    Keyword    artists
    Delete All Sessions    
    &{headersData} =    Create Dictionary    Authorization    Bearer ${invalidToke}    Content-Type    application/json
    &{jsonData} =    Create Dictionary    grant_type    client_credentials
    Create Session    ${sessionName}    ${baseURL}    verify=false    headers=${headersData}


*** Test Cases ***
Get an Artist
    [Documentation]    Test case to check get artist
    [Tags]    Critical    Happy
    Given Init URL to get an artist    ${validArtistId}
    When Use get an artist request    ${artistURL}
    Then The response code is the given code    200
    And The response json is not empty
    And The response json has the given name    ${validArtistName}

Get an Artist with ivalid id
    [Documentation]    Test case to check get artist with invalid id
    [Tags]    High    Unhappy
    Given Init URL to get an artist    ${inValidArtistId}
    When Use get an artist request    ${artistURL}
    Then The response code is the given code    404

Get an Artist with invalid token
    [Documentation]    Test case to check get artist with invalid token
    [Tags]    Medium    Unhappy
    Given Invalid token in session
    And Init URL to get an artist    ${validArtistId}
    When Use get an artist request    ${artistURL}
    Then The response code is the given code    401
    [Teardown]    Refresh session in Spotify API

Get an Artist with empty id
    [Documentation]    Test case to check get artist with empty id
    [Tags]    Low    Unhappy
    Given Init URL to get an artist    ${EMPTY}
    When Use get an artist request    ${artistURL}
    Then The response code is the given code    400