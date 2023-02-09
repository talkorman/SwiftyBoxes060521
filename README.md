# SwiftyBoxes060521
Visual calculation application for arranging packaging in shipping containers with maximum optimization

link to the app:
https://apps.apple.com/il/app/swifty-boxes/id1565388121?l=iw

link to demonstration of the simulation on iphone:
https://www.youtube.com/watch?v=vvWxUZvBrkQ

link to demonstration of the web app:
https://www.youtube.com/watch?v=DvP-H1Tc5lQ

link for tutorial:
https://swiftyboxesspecs.herokuapp.com

General information:

Swifty Boxes is a full stack app for iOS devices.
It contains the following software technologies:

Front end - iOS Swift

Back end - Node JS, Mongo DB.

General functionality:

The app receive an input from the user of packing list consignment, calculating the best optimized configuration for loading the packages into shipping containers. after calculating, it shows the user the loading proces on a visual 3D scene.
The user can use as many packing lists as he need, save and edit them on the server of the app.

The core code of the app sit on the server. It's an algoritm that I developed 2 years ago, it performs the calculating: it receive the whole packing list information and return a data which contain the conform containers and the packaging content with each package location and position.
The front end adding some functuinality to the process of the loading - the loading order.

Framework and libraries:

The app UI use Scenekit library for rendering the graphics.

On the backend it use Express, Mongoose, Bycrypt, Crypto, Jsonwebtoken and Nodemailer which sit on Heroku server and connected to MongoCB that saves all the users and packing lists information.

Design patterns used at the Front end:

1. Delegate - for TableView cells editing and deleting
2. Callback - for network requests
3. Singleton - for storing main common variables and control the communication between the View controllers and the internet terminal object.
4. Key Value Observer - for observing the communication status and accordingly to change the login alert status.
5. MVC - to seperate between the models of the data, app functionality of and the UI.
6. Factory function - for creating 3D packages objects from the data of the algoritm returned from the server.


Special programing technics used at the front end:

1. Regex - for email and password input control.
2. Token interception - for inserting the token to the data requests before sendin to the server.
3. Enum with String raw value + String split – for easy manipulation of the internet request function for all the types of requests by spliting the raw value enum string that include request type and api address.
4. Sorting array of objects – for orientation of the loading process from inside the container to outwards the container.
5. Computed variables - for converting between Swift Int and NS Int64 on Core Data.
6. Scene Kit Physics – for pushing the container and it’s content with an effect of a kick.
7. Timers for controlling the loading process speed.
8. Recursion function – for repeating loading package animation until the last package.
9. Repeating array indexing with modulu – for keeping the color of the box for each box type and returning from last index to 0 index.
10. Rectangular frame over UILabel – for adding 3D shader material on the boxes with box frame and box name label.


The UI use a Core Data to save the current packing list information and Default data for the Token and other variables that are important for on restart run time.


Design patterns used at the back end:

1. Router - for seperation of the User, Post models and the loading calculation algoritm. 
2. Encrypt - for encrypting the user and password name on the Data base.
3. Promise - for asynchronic manipulation of the requests and the returned data.
4. Token - for login control.
5. Chaining of functions - for running multiple manipulation functions in a single line of doce on the loading calculation algoritm.
6. Factory function - for converting and creating new objects from the information of the calculated objects in Java Script with Integers paremeters to a new swift objects that works with Float parameters.
7. Callback - for waiting until the loading calculating algoritm complete the calculation which can be differ according to complexity of the packing list content.



Programing technics used at the back end:

1. Password reset  - for reseting the password through the user mail box.
2. Regex - for password control on reset password page.

The loading algoritm is not exposed here for commercial reasons.


Future plan:

1. To add the option of using pallets loading calculation when the user choose to add pallets.
2. To add the option of loading cylinder packages - some packages of raw materials are packed in cylinder packages.
3. To add weight constrains to the calculation to protect the loading process follows loading international rules.
4. To add package attributes such as 'allowed' or not allowed' load on a certain package.
