gitsum
======
easy deployment with node.js and git

##Overview
This module will allow you to easily create a heroku-like deployment environment on your own.

##Installation
Install this on both your local machine as well as your remote server by running this command:
```
npm install -g gitsum
```

##Usage
###gitsum server
Inside an initialized git repository, run the following to start the server:
```
gitsum server
```
This server running on **port 3013** is watching for incoming commit requests. When it receives a valid commit request, gitsum will automatically pull and merge your changes on the server.<br><br>
To run gitsum server on a different port, use the -p option:
```
gitsum server -p 3000
```

###gitsum push
 
