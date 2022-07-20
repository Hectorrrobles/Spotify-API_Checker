# 
# Author: Hector Rodriguez (hectorrrobles84@gmail.com)
# 01__POST.robot (c) 2022
# 
*** Settings ***
Force Tags        Spotify API    POST
Resource          ../main.resource
Suite Setup       Init session in Spotify API
Suite Teardown    End session in Spotify API

*** Variables ***

*** Keywords ***
Init URL to post a playlists
    [Documentation]    Keywords to generate the URL to get the artist data with given ID
    [Tags]    Keyword    artists
    ${meURL} =    Catenate    SEPARATOR=/    ${baseURL}    v1    me
    ${responseMe} =    GET On Session    ${sessionName}    ${meURL}    expected_status=any
    ${playlistsURL} =    Catenate    SEPARATOR=/    ${baseURL}    v1    users    ${responseMe.json()}[id]    playlists
    Set Test Variable    ${playlistsURL}


*** Test Cases ***
Create a Playlist
    [Documentation]    Test case to check create playlist process
    [Tags]    Critical    Happy
    Given Init URL to post a playlists
