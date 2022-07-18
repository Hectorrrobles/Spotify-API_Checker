# Spotify-API Checker
It is a project to generate a tests catalogue with Spotify public API


## Details
For this project I will use [Spotify public API](https://developer.spotify.com/) to check the **Get an Artist** and **Create a Playlist** process.

### Language 
I'm going to use *Python 3.8.8*

### Framework
I'm going to use [robotframework](https://robotframework.org/) as automation framework with python.

### Environment
I'm going to use a [virtual python environment](https://docs.python.org/3/tutorial/venv.html) and use **requirements.txt** to install the packages.

## Objective
I design a tests catalogue with [Gherkin Syntax](https://cucumber.io/docs/gherkin/).

The endpoints in scope are:
1. Get an Artist
~~~
GET [https://api.spotify.com/v1/artists/{id}]
~~~
2. Create a Playlist
~~~
POST [https://api.spotify.com/v1/users/{user_id}/playlists]
~~~
