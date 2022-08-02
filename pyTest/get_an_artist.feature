Feature: Get an artist from Spotify Api

    Scenario: Get an Artist
        Given Init URL to get an artist '6XyY86QOPPrYVGvF9ch6wz'

        When Use get an artist request

        Then The response code is 200
        And The artist name is 'Linkin Park'