"""
Author: Hector Rodriguez (hectorrrobles84@gmail.com)
tools.py (c) 2022
"""


import base64, logging, requests

class tools:
    """Class to store functions which need in RobotFramework tests suites."""
    def __init__(self,tokenURL="https://accounts.spotify.com/api/token") -> None:        
        self.__tokenURL = tokenURL

    def __encodeToBase64(self,clientId,clientSecret):
        """Private function to encode clientId and clientSecret for token request"""

        logging.debug("Call private function encodeToBase64")
        credentials = f"{clientId}:{clientSecret}"
        credentialsBytes = credentials.encode('ascii')
        credentialsBase64 = base64.b64encode(credentialsBytes)

        return credentialsBase64.decode('ascii')
    
    def getAccesToken(self,clientId,clientSecret):
        """Public function to get access token from given client data"""

        logging.debug("Call public function getAccesToken")
        data = {}
        headers = {}

        base64Message = self.__encodeToBase64(clientId,clientSecret)
        headers['Authorization'] = f"Basic {base64Message}"
        data['grant_type'] = "client_credentials"
        requestResults = requests.post(self.__tokenURL, headers=headers, data=data)

        return requestResults.json()['access_token']