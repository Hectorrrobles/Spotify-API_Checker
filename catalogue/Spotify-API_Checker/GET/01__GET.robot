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

*** Keywords ***
Init URL to get an artist
    [Documentation]    Keywords to generate the URL to get the artist data with given ID
    [Tags]    Keyword    artists
    [Arguments]    ${givenId}
    ${artistURL} =    Catenate    SEPARATOR=/    ${baseURL}    v1    artists    ${validartistId}
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


*** Test Cases ***
Get an Artist
    [Documentation]    Test case to check get artist from Spotify Api
    [Tags]    Critical    Happy
    Given Init URL to get an artist    ${validArtistId}
    When Use get an artist request    ${artistURL}
    Then The response code is the given code    200
    And The response json is not empty
    And The response json has the given name    ${validArtistName}