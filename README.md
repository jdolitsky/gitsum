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
*Note: both your machine and the server must have read/write access to the same remote repository.*

##Usage
###(1) gitsum server
Inside an initialized git repository, run the following to start the server:
```
gitsum server
```
This server running on **port 3013** is watching for incoming commit requests. When it receives a valid commit request, gitsum will automatically pull and merge your changes on the server.<br><br>
To run gitsum server on a different port (e.g. 3000), use the -p option:
```
gitsum server -p 3000
```

###(2) gitsum push
When you have made changes to the codebase on your local machine, you can add, commit, push your changes **AND** deploy those changes to the server all with one command:
```
gitsum push mysite.com
```
 \- where "mysite.com" is the host name of your server. You can also push directly to an IP address:
```
gitsum push 67.195.160.76
```
If your gitsum server is running on a port other than 3013, you must specify:
```
gitsum push mysite.com:3000
```
By default, the message on the commit is "gitsum push". If you want a custom message, just use the -m option:
```
gitsum push mysite.com -m "my commit message"
```

##License
(The MIT License)

Copyright (c) 2013 Josh Dolitsky <jdolitsky@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
