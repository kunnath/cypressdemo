Feature: Adding Asset

#Background:

Scenario: Should show error with invalid ISIN
 Given I navigate add asset page
    And I see field to add asset
    And I type 'SIN0000000010'
    And I click add Asset
   Then I see validation error message

Scenario: Should add new asset with valid ISIN
 Given I navigate add asset page
    And I see field to add asset
    And I type 'ISIN0000000015'
    And I click add Asset
   Then I see new asset is sucessfully added

Scenario: I see error message that assets exists
 Given I navigate add asset page
    And I see field to add asset
    And I type 'ISIN0000000015'
    And I click add Asset
   Then I see error message that assets exists





