# Hype

In this four day project students will learn the basics of the CloudKit framework.

## Day 1 - Intro to CloudKit, CKRecords, CloudKit Dashboard
### Documentation links
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [CKContainer](https://developer.apple.com/documentation/cloudkit/ckcontainer)
- [CKRecord](https://developer.apple.com/documentation/cloudkit/ckrecord)

### Learning Objectives: 
- Implement CloudKit capabilities
- Define CKContainer and the difference between the Public and Private databases
- Define and implement CKRecord
- Beginning understanding of NSPredicate

### Talking points before begining
- Run the complete project (day4 branch) and talk about the daily goals. 
- Talk about cloud service backends and thier purpose. Discuss the benefits of using CloudKit.
- Talk about CKContainer, Public/Private Database, and zones (zones aren't important for their current level of understanding, but they should know they exist).
- Talk about CKRecord, key/value storage, and the similarities between CloudKit and CoreData

### Starting the project
#### Enable CloudKit
- Fork and clone repo, the master branch is the starter branch. The finished project for today is the day1 branch.
- On your project file, edit the Bundle ID to be com.X.Hype where X is the students name/initials. 
- Go to signings and capabilities and enable CloudKit, create the container 

#### Jump Into Code
##### Model
- Create the Hype model file and set it up normally with two properties, body and timestamp
- Talk about how, in order to save this model to the cloud, we need to package it into a CKRecord
- Create the CKRecord Extension and convenience init that takes in a Hype object
- Talk about how, when we retrieve that CKRecord from the cloud, we now need to convert it back into a Hype model object
- Extend the hype class and create the failiable init that takes in a CKRecord
- Add documentation to finish the file, have students explain what each line is doing

##### Model Controller
- Create the HypeController file, implement the singleton and source of truth array.
- Write the Create and Read function declarations
- Create the class publicDB property
- Talk about saving and retrieving data to the publicDatabase using .save and .perform on the database
- Fill in the body for the create method
  - Call the create method in AppDelegate to create a mock Hype and save it to the cloud
  - Go to the dashbord and go over the key/value pairs 
- Fill in the body for the fetch method
  - Call the fetch in AppDelegate to fetch the hypes that are getting created. 
  - Talk about marking records queryable in the database
  - Remove the methods from the AppDelegate
- Add documentation to finish the file, have students explain what each line is doing

##### ViewController and Storyboard
- Create and constrain the storyboard using a ViewController, tableView, and compose barButtonItem
- Drag out outlets/actions
- Conform to table view protocols and fill in the dataSource methods
- Create the setUpViews() method to set the tableView Delegate/DataSource and call it in viewDidLoad
- Implement the createHype method in the compose button action using the presentAddHypeAlert() method
- Create the updateViews() method to refresh the tableView when a hype has been created
- Create the loadData() method to fetch the hypes, run the app and talk about marking records queryable
- Create the UIRefreshControl, and implement it with loadData() and set the properties in the setUpViews() method
- Demo the finished day1 app

## Day 2 - Implement CKModifyRecordsOperation, and CKSubscription
### Documentation Links
- [CKModifyRecordsOperation](https://developer.apple.com/documentation/cloudkit/ckmodifyrecordsoperation)
- [CKSubscription](https://developer.apple.com/documentation/cloudkit/cksubscription)

### Learning Objectives
- Define CKModifyRecordsOperation, why we use it, and the general purposes of Operations
- Define CKSubscription, silent vs public notifications.

### Talking points before beginning
- Discuss goal of implementing Update and Delete for Hype objects using an Operation.
  - Thread safety
  - Quality of Service 
  - Built in completion blocks
- Implementing CKSubscription for user notifications
  - Silent vs Public (registering for remote notifications)

### Starting the project
#### CKModifyRecordsOperation

##### ModelController
- Delcare the update(hype:) and delete(hype:) method declaration
- In update(hype:) call the .add(Operation) method on the publicDB.
- Follow the steps to complete the implementation of the CKModifyRecordsOperation to update existing records
- Do the same process for delete(hype:), have the students walk through the code, using update(hype:) for an example
- Add documentation to the methods, have students explain what each line is doing

##### ViewController
- Edit the presentHypeAlert() method to take in an optional Hype object to allow for editing. 
- Edit the addHypeAction to check if a hype was passed in and implement the udpate(hype:) method
- Implement the didSelectRowAt tableView method to grab the hype you wish to edit and pass it into the presentHypeAlert(for hype:) method

#### CKSubsription
##### AppDelegate
- Import UserNotificationCenter and request authorization for notificatino
- Import CloudKit to implement didRegisterForRemoteNotificationWithDeviceToken, didFailToRegisterForRemoteNotificationsWithError, and didReceiveRemoteNotifaction
- In the didReceiveRemoteNotification method, call fetchAllHypes to refresh the hype list
- Talk about CKSubscription

##### ModelController
- Declare the subscribeFOrRemoteNotifications() method
- Initialize a CKQuerySubscription, init the required predicate
- Change all the properties on the subscription that we care about
- Save the subscription to the publicDB
- Demo the subscription notifications

##### AppDelegate
- Implement applicationDidBecomeActive to set the badge number to 0 when the app is opened


## Day 3 - CKRecord.Reference, CKUserIdentity
### Documentation Links

- [CKUserIdentity](https://developer.apple.com/documentation/cloudkit/ckuseridentity)
  - Specifically the userRecordID property for referencing the AppleID User.
  - Can touch on UserDiscoverability, but also mention that you can't edit the properties on the Users type in the dashboard. 
- [CKRecord.Reference](https://developer.apple.com/documentation/cloudkit/ckrecord/reference)

### Talking points before beginning
- What is a CKRecord.Reference, touch on similarities to Relationships in CoreData
- CKUserIdentity being an AppleID User that you can use for authentication

#### CKRecord.Reference
##### User Model
- Create the User file and declare the User class with the username, bio, recordID, and appleUserReference properties
- Create all needed initializers
- Add documentation to initializers, have students explain what each line does

##### UserController
- Create the UserController file and declare the class, implement the singleton and currentUser properties
- Declare the needed CRUD functions
- Begin filling out the createUser() method, and notice that we need a Reference to initialize the User

#### CKUserIdentity
- Delcare the fetchAppleUserReference() method, and walk through what it is doing
  - Built in CloudKit method to fetch the CKRecord.ID for the currently logged in "Users" object
  - We can use that to create a reference to our custom User object to handle login/account authentication
  
#### CKRecord.Reference Cont.
- Call the fetchAppleUserReference() method in the creatUser() method and continue filling it out
- Fill in the fetchUser() body, showing how we need to implement the fetchAppleUserReference() again.
- Add documentation, have students explain what each line does
 

##### Hype Model
Currently the Hype objects have no reference to our custom User object. We need to refactor the model so Hypes point back to the User that created it.
- Add the userReference property, mark it optional to account for existing Hypes without a reference
- Include the userReference in the designated init, failable init, and CKRecord extension

##### HypeController
Changing the Model requres us to refactor the ModelController as well
- Add the userReference property to the saveHype() method


##### ViewControllers && Storyboards
- Create and constrain the SignUpViewController, make it the initial viewController
- Refactor the HypeListViewController and it's navigationController to a new storyboard file
- Create the SignUpViewController file and wire up the views
- Declare a fetchUser() method where we call the UserController's fetchUser method. We do this to keep the viewDidLoad as clean as possible.
- If we complete with success, we need to present the HypeListViewController
- Declare the presentHypeListVC() method and walk through presenting the viewController we need programatically
- If the fetchUser doesn't succeed, we need to give ourselves a way to create a User throught the sighUpButton action.
- Implement the UserController createUser() method in the button action, and call the presentHypeListVC() method if it completes with success
- Demo the app

##### If there is time...
- We have added in specific Users, but currently there is no way for us to distinguish who owns what hype. Anyone can make edits or delete any hype.
- Refactor the update(hype:) and delete(hype:) to take that into account.

## Day 4 - CKAsset
### Documentation Links
[CKAsset](https://developer.apple.com/documentation/cloudkit/ckasset)

### Talking points before beginning
- Talk about storing data in the cloud with CKAsset
  - Documentation is very helpful here (stored separate, saves only one copy of the asset).
- Talk about the flow of data for storing something in a CKAsset and fetching an asset and transforming it back
  - Very similar to the process of CKRecords
  
#### CKAsset
##### User Model
- Create the profilePhoto property, the photoData property, and the photoAsset property
- Include the profilePhoto in the designated initializer with a default value of nil
- Wite the get/set for the profilePhoto property
- Write the get for the photoAsset
- Include the photoAsset in the CKRecord Extension init
- Unwrap the image in the failable init
- Add documentation, have students explain what each line is doing

##### UserController
- Edit the createUser() method to accomodate the optional phofilePhoto

##### SignUpViewController
- Add in and constrain the containerView
- Add an imageView and button to the new ViewController

##### PhotoPickerViewController
- Create the imagePicker property
- Create the PhotoSelectorDelegate protocol, fill in the protocol method, and create the delegate property on the class
- Create the PhotoPickerViewController file, subclass and wire up the views
- In the selectPhoto action, create an alert controller with three actions: Cancel, Camera, Photo Library
  - In the closure for cancel, call dismiss on the imagePicker, leave the other closures empty for now
- Extend the class and conform to UIImagePickerControllerDelegate && UINavigationControllerDelegate
- Implement the delegate method didFinishPickingMediaWIthInfo
  - Unwrap the selected image and the delegate, then call the delegate.photoPickerSelected(image:) method
  - Set the imageView's image to the selected image, and dismiss the picker
- Declare and fill out the openCamera() and openGallery() methods
- Call the methods in the cameraAction and photoLibraryAction above
- Declare and fill out the setupViews() method
- Call setupViews() in viewDidLoad

##### SignUpViewController
- Create the image property
- Extend the class and conform to the PhotoSelectorDelegate protocol, setting self.image = image in the fuction body
- Include the profilePhoto parameter in the createUser() method, pass in the image property
- Override prepare(for segue:) and assign the delegate for the PhotoPickerViewController
- Declare and fill out the setupViews() method, call it in viewDidLoad
- Delete the current User in the dashboard and test the code

##### Hype Model
Follow the same process to implement photos on Hype objects.
- Add the hypePhoto, photoData, and photoAsset properties
- Include the photo in the designated init with a default value of nil
- Include the photoAsset in the CKRecord Extension init
- Unwrap and set the photo in the clas failable init
- Add documentation and have students explaine line by line

##### HypeController
- Include a photo parameter in the saveHype() method, pass it in the newHype constant init as well


##### HypeListViewController && HypeList.storyboard 
- Add in a camera barButtonItem next to the compose button
- Create a modal segue to a new ViewController
- Constrain the view elements for the HypePhotoViewController, create the file, and wire up the views
  - You will need to refactor the PhotoPickerViewController into it's own storyboard to drag out the embed segue to the storyboard reference

##### HypePhotoViewController
- In the viewController file conform to the PhotoSelectorDelegate
  - Create an image property on the class
  - Set the self.image = image in the protocol delegate method
  - Set the delegate for the imagePicker in prepare(for segue:)
- In the confirmButton action, unwrap the image and text from the outlets, and call the HypeController saveHype() method
- Declare and fill in the dismissView() method
  - Call this in the completion for the saveHype and cancelButton action
- Declare and fill in the setupViews() to make the imageView look nice
