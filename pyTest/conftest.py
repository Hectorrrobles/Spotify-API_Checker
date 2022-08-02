"""
Author: Hector Rodriguez (hectorrrobles84@gmail.com)
conftest.py (c) 2022
"""
import pytest

def pytest_addoption(parser):
    parser.addoption("--clientId", action="store", help="input clientId")
    parser.addoption("--clientSecret", action="store", help="input clientSecret")
    parser.addoption("--authorizeToken", action="store", help="input authorizeToken")

@pytest.fixture
def params(request):
    params = {}
    params['clientId'] = request.config.getoption('--clientId')
    params['clientSecret'] = request.config.getoption('--clientSecret')
    params['authorizeToken'] = request.config.getoption('--authorizeToken')
    if params['clientId'] is None or params['clientSecret'] is None:
        pytest.skip()
    return params