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
&{publicPlaylistData} =    name=Public Playlist    description=Public playlist description    collaborative=False    public=True
&{privatePlaylistData} =    name=Private Playlist    description=Private playlist description    collaborative=False    public=False
&{collaborativePlaylistData} =    name=Collaborative Playlist    description=Collaborative playlist description    collaborative=True    public=False
&{publicCollaborativePlaylistData} =    name=Public Playlist    description=New public playlist description    collaborative=True    public=True
&{otherLanguagePlaylistData} =    name=한국인    description=한국어 재생 목록    collaborative=False    public=False

&{emptyNamePlaylistData} =    name=${EMPTY}    description=Playlist without name    collaborative=False    public=True
&{emptyDescriptionPlaylistData} =    name=Playlist without description    description=${EMPTY}    collaborative=False    public=True
&{emptyPublicTypePlaylistData} =    name=Playlist without public type    description=Description without public type    collaborative=False    public=${EMPTY}
&{emptyCollaborativePlaylistData} =    name=Playlist without collaborative    description=Description without collaborative    collaborative=${EMPTY}    public=True

&{withoutNamePlaylistData} =    description=Description without name    collaborative=False    public=True
&{withoutDescriptionPlaylistData} =    name=Without description Playlist    collaborative=False    public=True
&{withoutPublicTypePlaylistData} =    name=Without public type Playlist    description=Playlist description    collaborative=False
&{withoutCollaborativePlaylistData} =    name=Without Collaborative Playlist    description=Playlist description    public=True



*** Keywords ***
Init URL to post a playlists
    [Documentation]    Keywords to generate the URL to create playlist
    [Tags]    Keyword    playlist
    ${meURL} =    Catenate    SEPARATOR=/    ${baseURL}    v1    me
    ${responseMe} =    GET On Session    ${sessionName}    ${meURL}    expected_status=any
    ${createPlaylistsURL} =    Catenate    SEPARATOR=/    ${baseURL}    v1    users    ${responseMe.json()}[id]    playlists
    Set Test Variable    ${createPlaylistsURL}

Create a playlist with given data
    [Documentation]    Keywords to create a playlist with given data
    [Tags]    Keyword    playlist
    [Arguments]    &{givenData}
    ${response} =    POST On Session    ${sessionName}    ${createPlaylistsURL}    json=${givenData}    expected_status=any
    Set Test Variable    ${response}

The playlist exits
    [Documentation]    Keywords to check if the public playlist exists
    [Tags]    Keyword    playlist
    [Arguments]    ${playlistId}    &{oriPlaylistData}
    ${playlistsURL} =    Catenate    SEPARATOR=/    ${baseURL}    v1    playlists    ${playlistId}
    ${responsePlaylist} =    GET On Session    ${sessionName}    ${playlistsURL}    expected_status=any  
    Should Contain    "${responsePlaylist}"    200
    Should Contain    "${responsePlaylist.json()}[name]"    ${oriPlaylistData}[name]
    Should Contain    "${responsePlaylist.json()}[description]"    ${oriPlaylistData}[description]
    Should Contain    "${responsePlaylist.json()}[collaborative]"    ${oriPlaylistData}[collaborative]
    Should Contain    "${responsePlaylist.json()}[public]"    ${oriPlaylistData}[public]

*** Test Cases ***
Create a public playlist
    [Documentation]    Test case to check create public playlist process
    [Tags]    Critical    Happy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{publicPlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{publicPlaylistData}

Create a public playlist with invalid token
    [Documentation]    Test case to check error in process to create public playlist with invalid token
    [Tags]    High    Unhappy
    Given Init URL to post a playlists
    And Invalid token in session
    When Create a playlist with given data    &{publicPlaylistData}
    Then The response code is the given code    401
    [Teardown]    Refresh session in Spotify API

Create a private playlist
    [Documentation]    Test case to check create private playlist process
    [Tags]    Critical    Happy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{privatePlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{privatePlaylistData}

Create a playlist in other Language
    [Documentation]    Test case to check create playlist in toher language process
    [Tags]    Medium    Happy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{otherLanguagePlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{otherLanguagePlaylistData}

Create a collaborative playlist
    [Documentation]    Test case to check create collaborative playlist process
    [Tags]    Medium    Happy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{collaborativePlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{collaborativePlaylistData}

Create a public collaborative playlist
    [Documentation]    Test case to check error in process to create public collaborative playlist
    [Tags]    Medium    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{publicCollaborativePlaylistData}
    Then The response code is the given code    400

Create a playlist with empty name
    [Documentation]    Test case to check error in process to create playlist with empty name
    [Tags]    High    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{emptyNamePlaylistData}
    Then The response code is the given code    400

Create a playlist with empty description
    [Documentation]    Test case to check process to create playlist with empty description
    [Tags]    High    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{emptyDescriptionPlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{emptyDescriptionPlaylistData}    description=""

Create a playlist with empty public type
    [Documentation]    Test case to check process to create playlist with empty public type
    [Tags]    High    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{emptyPublicTypePlaylistData}    
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{emptyPublicTypePlaylistData}    public=False

Create a playlist with empty collaborative
    [Documentation]    Test case to check process to create playlist with empty collaborative
    [Tags]    High    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{emptyCollaborativePlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{emptyCollaborativePlaylistData}    collaborative=False

Create a playlist without name
    [Documentation]    Test case to check error in process to create playlist without name
    [Tags]    Low    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{withoutNamePlaylistData}
    Then The response code is the given code    400

Create a playlist without description
    [Documentation]    Test case to check process to create playlist without description
    [Tags]    Low    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{withoutDescriptionPlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{withoutDescriptionPlaylistData}    description=""

Create a playlist without public type
    [Documentation]    Test case to check process to create playlist without public type
    [Tags]    Low    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{withoutPublicTypePlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{withoutPublicTypePlaylistData}    public=True

Create a playlist without collaborative
    [Documentation]    Test case to check process to create playlist without collaborative
    [Tags]    Low    Unhappy
    Given Init URL to post a playlists
    When Create a playlist with given data    &{withoutCollaborativePlaylistData}
    Then The response code is the given code    201
    And The playlist exits    ${response.json()}[id]    &{withoutCollaborativePlaylistData}    collaborative=False