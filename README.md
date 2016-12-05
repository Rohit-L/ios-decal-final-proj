# QuickShare

## Authors

* Rohit Lalchandani
* Shreyas Bhave

## Purpose

QuickShare allows users to rent everyday common items from other users and also
post their own belongings to be rented by other users. These can be things such
as vacuum cleaners, kitchen applainces and other tools.

## Features

- View list of items that can be rented
- View list of items that you are leasing
- View item info screen with more details about item
	- if item is an item you are leasing, then display editable fields for 
		description, contact, title, and photo (optional)
	- it item is a rentable item, then user can view title, description of item,
		contact information of user leasing the item, and photo (optional) of 
		item
- Ability to create a new item that can be rented by other users
- Ability to delete item created by user
- Ability to view profile information for users including name, 
photo (opitonal), and contact information. 

## Control Flow

- Starting with login page, users must login and authenticate themselves with 
some external service such as Facebook or Twitter (undecided). If they already 
have a logged-in session, then they are taken to the home screen.
- At the home screen, users can see a list of items (showing title) that they 
can rent. If the user taps on one of the items, they are taken to an item info 
screen.
- At the item info screen, the user is able to see more information about the 
item such as title, description, photo (optional), contact information, and the
username of the user who posted the item.
- Tapping on the username, the user is taken to the posters profile, which shows
the posters name, contact info, a photo (optional) of the user, and a list of
items that user is leasing.
- At the bottom of the screen is a navbar that has a button to go to the user's
own profile page which has the users name, photo (optional), and list of items
the users is leasing. In the titlebar of this screen is an add button that takes
the user to an add item screen.
- At the add item screen, the user is able to fill in fields for a new item
including description, title, and photo (optional, from photo gallery). In the
titlebar, the user can choose 'cancel' to return to his/her profile screen or
'done' to post the item and return to his/her profile screen.

## Implementation

### Model
* Item.swift

### View
* LoginView
* RentableItemsListTableView
* ItemView
* ProfileView
* AddItemView

### Controller
* LoginViewController
* RentableItemsTableViewController
* ItemViewController
* ProfileViewController
* ProfileItemListTableViewController
* AddItemViewController
