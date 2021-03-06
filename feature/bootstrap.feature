# Copyright IBM Corp. 2017 All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Feature: Bootstrapping Hyperledger Fabric
    As a user I want to be able to bootstrap my fabric network

@daily
Scenario: FAB-3635: Bootstrap Network from Configuration files
    Given I have a fabric config file
    When the network is bootstrapped for an orderer
    Then the "orderer.block" file is generated
    When the network is bootstrapped for a channel named "mychannel"
    Then the "mychannel.tx" file is generated

@daily
Scenario: FAB-3854: Ensure genesis block generated by configtxgen contains correct data
    Given I have a fabric config file
    When the network is bootstrapped for an orderer
    Then the "orderer.block" file is generated
    And the orderer block "orderer.block" contains MSP
    And the orderer block "orderer.block" contains root_certs
    And the orderer block "orderer.block" contains tls_root_certs
    And the orderer block "orderer.block" contains Writers
    And the orderer block "orderer.block" contains Readers
    And the orderer block "orderer.block" contains BlockValidation
    And the orderer block "orderer.block" contains HashingAlgorithm
    And the orderer block "orderer.block" contains OrdererAddresses
    And the orderer block "orderer.block" contains ChannelRestrictions
    And the orderer block "orderer.block" contains ChannelCreationPolicy
    And the orderer block "orderer.block" contains mod_policy
    When the network is bootstrapped for a channel named "mychannel"
    Then the "mychannel.tx" file is generated
    And the channel transaction file "mychannel.tx" contains Consortium
    And the channel transaction file "mychannel.tx" contains mychannel
    And the channel transaction file "mychannel.tx" contains Admins
    And the channel transaction file "mychannel.tx" contains Writers
    And the channel transaction file "mychannel.tx" contains Readers
    And the channel transaction file "mychannel.tx" contains mod_policy

@daily
Scenario Outline: FAB-3858: Verify crypto material (TLS) generated by cryptogen
    Given I have a crypto config file with <numOrgs> orgs, <peersPerOrg> peers, <numOrderers> orderers, and <numUsers> users
    When the crypto material is generated for TLS network
    Then crypto directories are generated containing tls certificates for <numOrgs> orgs, <peersPerOrg> peers, <numOrderers> orderers, and <numUsers> users
    Examples:
       | numOrgs | peersPerOrg | numOrderers | numUsers |
       |    2    |      2      |      3      |     1    |
       |    3    |      2      |      3      |     3    |

@daily
Scenario Outline: FAB-3856: Verify crypto material (non-TLS) generated by cryptogen
    Given I have a crypto config file with <numOrgs> orgs, <peersPerOrg> peers, <numOrderers> orderers, and <numUsers> users
    When the crypto material is generated
    Then crypto directories are generated containing certificates for <numOrgs> orgs, <peersPerOrg> peers, <numOrderers> orderers, and <numUsers> users
    Examples:
       | numOrgs | peersPerOrg | numOrderers | numUsers |
       |    2    |      2      |      3      |     1    |
       |    3    |      2      |      3      |     3    |
       |    2    |      3      |      4      |     4    |
       |    10   |      5      |      1      |     10   |
