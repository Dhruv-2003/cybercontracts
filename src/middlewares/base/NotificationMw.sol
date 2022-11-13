// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;
  
interface IPUSHCommInterface {
    function sendNotification(
        address _channel,
        address _recipient,
        bytes calldata _identity
    ) external;
}

/**
 * @title Notification Middleware
 * @author Dhruv-2003
 * @notice This contract is a middleware that handle notifications via PUSH.
 */
contract NotificationMw {

    /// EPNS CONTRACT ADDRESS according to the respective Chain 
    address public EPNS_COMM_CONTRACT_ADDRESS =  ;

    /// CHAIN ACTIVE ON : ETH_TEST_KOVAN, ETH_MAINNET, POLYGON_MAINNET, POLYGON_TEST_MUMBAI, THE_GRAPH

    /**
     * @notice Sends the Notification Via Push channel.
     * @param CHANNEL_ADDRESS -  Address of the Channel for the notification
     * @param recipient - Address of the reciver for the notification 
     * @param title - Title of the notification
     * @param body -  Body / message of the notification
     */
    function sendNotificationViaPush(address CHANNEL_ADDRESS , address recipient ,string memory title , string memory body) internal {

        IPUSHCommInterface(EPNS_COMM_CONTRACT_ADDRESS)
            .sendNotification(
                CHANNEL_ADDRESS, // from channel - recommended to set channel via dApp and put it's value -> then once contract is deployed, go back and add the contract address as delegate for your channel
                recipient, // to recipient, put address(this) in case you want Broadcast or Subset. For Targetted put the address to which you want to send
                bytes(
                    string(
                        // We are passing identity here: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                        abi.encodePacked(
                            "0", // this is notification identity: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                            "+", // segregator
                            "3", // this is payload type: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/payload (1, 3 or 4) = (Broadcast, targetted or subset)
                            "+", // segregator
                            title, // this is notificaiton title
                            "+", // segregator
                            body
                        )
                    )
                )
            );
    }

    /**
     * @notice Helper function to convert address to string
     * @param _address - Address to be converted into String
     * @return - string form of the Address
     */
    function addressToString(address _address) internal pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(uint160(_address)));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _string = new bytes(42);
        _string[0] = '0';
        _string[1] = 'x';
        for(uint i = 0; i < 20; i++) {
            _string[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _string[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }
        return string(_string);
    }

    /**
     * @notice Helper function to convert uint to string
     * @param _i - uint to be converted
     * @return - string form of the uint
     */
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
