// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.14;

import {IEssenceMiddleware} from "../../interfaces/IEssenceMiddleware.sol";
import {NotificationMw} from "./NotificationMw.sol";

/**
 * @title Collect Disallowed Middleware
 * @author Dhruv-2003
 * @notice This contract is a middleware to disallow any collection to the essence that uses it.
 */
contract CollectNotificationMw is IEssenceMiddleware, NotificationMw {
    /*//////////////////////////////////////////////////////////////
                               STATES
    //////////////////////////////////////////////////////////////*/
    address public SUBSCRIBE_CHANNEL_ADDRESS;

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address _ChannelAddress) {
        SUBSCRIBE_CHANNEL_ADDRESS = _ChannelAddress;
    }

    /*//////////////////////////////////////////////////////////////
                         INTERNAL VIEW
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Send notificaton the the Profile about the subscriber who subscribed to the user
     */
    function sendCollectNotification(
        address collector,
        address profile,
        uint256 essenceID
    ) internal {
        IPUSHCommInterface(EPNS_COMM_CONTRACT_ADDRESS).sendNotification(
            SUBSCRIBE_CHANNEL_ADDRESS, // from channel - recommended to set channel via dApp and put it's value -> then once contract is deployed, go back and add the contract address as delegate for your channel
            profile, // to recipient, put address(this) in case you want Broadcast or Subset. For Targetted put the address to which you want to send
            bytes(
                string(
                    // We are passing identity here: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                    abi.encodePacked(
                        "0", // this is notification identity: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                        "+", // segregator
                        "3", // this is payload type: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/payload (1, 3 or 4) = (Broadcast, targetted or subset)
                        "+", // segregator
                        "Collect Alert !!", // this is notificaiton title
                        "+", // segregator
                        "Hooray !! ",
                        addressToString(subscriber),
                        "Collected your Essence with ID :  ",
                        uint2str(essenceID)
                    )
                )
            )
        );
    }

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IEssenceMiddleware
    function setEssenceMwData(
        uint256,
        uint256,
        bytes calldata
    ) external pure returns (bytes memory) {
        // do nothing
        return new bytes(0);
    }

    /**
     * @inheritdoc IEssenceMiddleware
     */
    function preProcess(
        uint256,
        uint256,
        address,
        address,
        bytes calldata
    ) external pure override {
        // do nothing
    }

    /**
     * @inheritdoc IEssenceMiddleware
     * @notice This process denies any attempts to collect the essence
     */
    function postProcess(
        uint256 profileId,
        uint256 essenceId,
        address collector,
        address,
        bytes calldata
    ) external {
        // fetch the Profile Address from the Profile Id
        address profileAddress;

        sendCollectNotification(collector, profileAddress, essenceID);
    }
}
