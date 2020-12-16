
# Nintendo game sales tracker (Title WIP)

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Stay up to date to your favorite Nintendo game wherever you go! This Nintendo app tracks sales on Nintendo games. While maintaining a track record, this app will give users the opportunity to learn, rate, watch live streams and be notified when a game on their favorites list goes on sale at certain retail locations. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Gaming / Social 
- **Mobile:** Mobile view only
- **Story:** Review Nintendo games, watch walkthroughs find the best deal to purchase a game
- **Market:** Everyone who has an interest in Nintendo games can make use of this app. 
- **Habit:** Users can ultilize this app throughout the day.
- **Scope:** This app's mission is to inform and create community for all Nintendo users. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Scale rating system and comment section rating,
* Display average play time
* Display livestreams from most popular 

**Optional Nice-to-have Stories**

* [fill in your required user stories here]
* games like this / similar games
* player streams via twitch
* favorite section


### 2. Screen Archetypes

* Login Screen
   * User can log in
   
* Registration Screen
   * User can create a new account
   
* Stream
   * User can view best priced games at current retail stores
   * User can watch playthroughs of their favorite games
   * User can click on a game and and it will give user the opportunity to rate and comment on the game. User can then click for more infomation on the game to review further details
   

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home menu
* Newest discounts
* Search for games

**Flow Navigation** (Screen to Screen)

* Login screen
   * Home
* Registration Screen
   * Home
* Stream Screen 
   * ...
   

## Wireframes
Digital Wireframe

<img src= "https://i.imgur.com/jF1OuZ9.jpg" width=600>


## Schema 

### Models
Property	Type	Description
		
|User Name|string| username for login,used to identy user|
| ------- | ---- | ------------------------------------- |
|password|string|	user's password for login|
|email|	string|	user's email|
|favorites|	array|	list of favorite games, games you will be watching for price drop|

### Networking

**login screen**


|POST|username|	
|----------- |------|
|post | password|	
		
**Registration**

|post|username	|
|---|---|
|post|	password|	
|post| 	email	|

<!--- - [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp] --->


		
**https://youtube.googleapis.com/youtube/v3/**

|Http verb|	end Point|	Description|
|--|--|--|
get| 	/youtube.channels.list/|	gets list of videos from the from a channels playlist|
get|	/youtube.playlist.list/	|Retrieve the playlist ID for the channel's uploaded videos|
get|	/youtube.videos.rate/	|get videos likes and dislikes|
		
**https://api.isthereanydeal.com/v01**

|Http Verb|	End Point	|Description|
|--|--|--|
|get|	/search/	|search game|
|get|	|user/wait/all/|Get list of games that the user has in Waitlist.|
|get|	/deals/list/	|provides list of deals|
|get|	/stats/waitlist/price/|	Get statistical info about Waitlist notification price limits for specific game|
|get |	game/plain/	|Identification by title tries to match provided title against our database. Should provide reasonable results|
|get|	/game/prices/	|Get all current prices for one or more selected games. Use region and country to get more accurate results|

## User Stories

The following **required** functionality is completed:

- [x] User can login using their Google Account
- [x] User can view the list of the trending games

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/hVE84LsxmD.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
