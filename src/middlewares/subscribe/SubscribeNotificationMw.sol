// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import {ISubscribeMiddleware} from "../../interfaces/ISubscribeMiddleware.sol";
import {NotificationMw} from "./NotificationMw.sol";

/**
 * @title Subscribe Notification Middleware
 * @author Dhruv-2003
 * @notice This contract is a middleware to get notifications when user subscribes to the user.
 */
contract SubscribeNotificationMw is ISubscribeMiddleware, NotificationMw {
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
    function sendSubscribeNotification(address subscriber, address profile)
        internal
    {
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
                        "Subscriber Alert !!", // this is notificaiton title
                        "+", // segregator
                        "Hooray !! ",
                        addressToString(subscriber),
                        "Subscribed to you"
                    )
                )
            )
        );
    }

    /*//////////////////////////////////////////////////////////////
                         EXTERNAL VIEW
    //////////////////////////////////////////////////////////////*/

    /**
     * @inheritdoc ISubscribeMiddleware
     */
    function setSubscribeMwData(uint256, bytes calldata)
        external
        pure
        override
        returns (bytes memory)
    {
        // do nothing
        return new bytes(0);
    }

    /**
     * @inheritdoc ISubscribeMiddleware
     */
    function preProcess(
        uint256,
        address,
        address,
        bytes calldata
    ) external pure override {
        // do nothing
    }

    /**
     * @inheritdoc ISubscribeMiddleware
     * @notice fetches the Profile address from profile Id and then sends the notification regarding the subscriber to the user
     */
    function postProcess(
        uint256 profileId,
        address subscriber,
        address,
        bytes calldata
    ) external override {
        // fetch the Profile Address from the Profile Id
        address profileAddress;

        sendSubscribeNotification(subscriber, profileAddress);
    }
}
