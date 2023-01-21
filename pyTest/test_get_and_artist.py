"""
Author: Hector Rodriguez (hectorrrobles84@gmail.com)
get_and_artist.py (c) 2022
"""
import logging
from pytest_bdd import scenario, given, when, then, parsers
import pytest
import requests
from src.tools import tools

def test_params(params):
    print(params)
    pytest.clientId = params['clientId']
    pytest.clientSecret = params['clientSecret']
    pytest.authorizeToken = params['authorizeToken']

@scenario('get_an_artist.feature', 'Get an Artist')
def test_publish():
    print("END")
    pass

@given(parsers.parse("Init URL to get an artist '{content}'"))
def init_url(content):
    token = tools().getAccesToken(pytest.clientId,pytest.clientSecret)
    if not pytest.authorizeToken is None: 
        token = pytest.authorizeToken
    pytest.headersData = {"Authorization":"Bearer %s" % token, "Content-Type":"application/json"}
    pytest.jsonData = {"grant_type":"client_credentials"}
    pytest.baseURL = "https://api.spotify.com"
    pytest.sessionUrl= "%s/v1/artists/%s" % (pytest.baseURL, content)

@when("Use get an artist request")
def post_Request():
    logging.debug(pytest.headersData)
    response = requests.get(pytest.sessionUrl, headers=pytest.headersData)
    pytest.response = response

@then(parsers.parse("The response code is {responseCode:d}"))
def VerifyPostInformation(responseCode):
    logging.debug("The response code must be %d" % responseCode)
    assert pytest.response.status_code == responseCode

@then(parsers.parse("The artist name is '{content}'"))
def VerifyPostInformation(content):
    logging.debug(content)
    assert pytest.response.json()['name'] == content