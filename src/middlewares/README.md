# CYBERCONNECT MIDDLEWARE CONTRACTS

**Author** - Dhruv-2003


## Idea and Use Case
-  I added notification feature to **Collect** and **Subscribe** CyberConnectMiddleWare Contracts.
-  This feature is added with the help of PUSH Protocol Integration. I used Send Notification via [SMART CONTRACT](https://docs.push.org/developers/developer-guides/sending-notifications/using-smart-contract)  method. 


## Motivation 
- Being a Social Graph Protocol, notifying users of the subscribers and Essence Collect will be a good feature to be added .


## Contracts Added
-  I made a Base Notification Contract called as [NotificationMw.sol](https://github.com/Dhruv-2003/cybercontracts/blob/main/src/middlewares/base/NotificationMw.sol). This Contract just intializes the PUSH Protocol Client and allows tot send Notification to a Channel Subscribed Address with a particular message.
- Then I implemented this base contract in the Subscribe and Collect Middle Interface.
- **SubscriberMw** is added [here](https://github.com/Dhruv-2003/cybercontracts/blob/main/src/middlewares/subscribe/SubscribeNotificationMw.sol) . The Profile Address being subscribed will get a notfication whenever a user subscribes the profile.
- **CollectMw** is added [here](https://github.com/Dhruv-2003/cybercontracts/blob/main/src/middlewares/essence/CollectNotificationMw.sol) .The Profile address will get a notification when someone collects the Essence.


## To Dos and Setup
- A Channel has to be created on PUSH Protocol's according to the chain/network on which the Contracts are deployed : This can be reffered here - https://docs.push.org/developers/developer-guides/create-your-notif-channel
- Users need to install the Push Extension or App - https://docs.push.org/developers/developer-guides/testing-sent-notifications
- To send a notification ,Profile Users needs to be subscribed to a particular channel via the Push Protocol's dApp . 
- Recieveing notification can be configured according to preference- https://docs.push.org/developers/developer-guides/receiving-notifications
- Then CHANNEL_ADDRESS and EPNS_COMM_CONTRACT_ADDRESS have to be set in the middleware contracts respectively. 
- The profile user address has to be fetched from the profileId which is passed as a argument in the `postProcess()` functions of the middleware contracts. Even on intense research I was not able to find the function that can perform this. Kindly configure that.


I enjoyed working with the middle ware Contracts and integrating PUSH protocol with CyberConnect. 
