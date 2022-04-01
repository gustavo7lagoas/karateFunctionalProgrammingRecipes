Feature: Karate Functional Programming Examples

  Background:
    * url 'https://jsonplaceholder.typicode.com'

  # It is a way to show how to use map/filter and currying
  Scenario: filter results
    * def fnStartWith = (startsWith) => word => word.startsWith(startsWith)
    * def getCommentEmail = function(comment) { return comment.email }
    Given path 'comments'
    When method get
    Then status 200
    # Gets a array of only comments emails
    * def allBodyComments = karate.map(response, getCommentEmail)
    # Gets an array of the email comments that start with c
    * def allCommentWithC = karate.filter(allBodyComments, fnStartWith('c'))
    # Using the JsonPath
    * def allEmailStartingWithCJsonPath = karate.jsonPath(response, "$.[?(@.email =~ /^c.*/im)].email")
    * print allEmailStartingWithCJsonPath

  Scenario: get all users and then get the first user by id
    Given path 'users'
    When method get
    Then status 200

    * def first = response[0]

    Given path 'users', first.id
    When method get
    Then status 200

  Scenario: create a user and then get it by id
    * def user =
      """
      {
        "name": "Test User",
        "username": "testuser",
        "email": "test@user.com",
        "address": {
          "street": "Has No Name",
          "suite": "Apt. 123",
          "city": "Electri",
          "zipcode": "54321-6789"
        }
      }
      """

    Given url 'https://jsonplaceholder.typicode.com/users'
    And request user
    When method post
    Then status 201

    * def id = response.id
    * print 'created id is: ', id

    Given path id
    When method get
    Then status 200
    And match response contains user
  