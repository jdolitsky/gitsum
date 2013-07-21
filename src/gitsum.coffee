exec = require('child_process').exec

remote = 'origin'
branch = undefined
interval = undefined
remote_server = undefined
port = undefined
port_switch = undefined

mode = process.argv[2]
arg3 = process.argv[3]
arg4 = process.argv[4]
arg5 = process.argv[5]

help = 'look dude read the manual'
message = 'gitsum push'

server_commands = ['s','S','server']
push_commands = ['p','P','push']
message_switch = ['-m', '-M']
port_switch = ['-p', '-P']

if mode in server_commands
  port = 3013
  if arg3 in port_switch
    if arg4 and /^\d+$/.test arg4
      port = arg4
    else
      console.log "warning: please include a valid port number when using -p option"

  console.log 'starting gitsum server...'
  console.log 'server listening at '+'localhost'+':'+port
 
  express = require 'express'
  app = express()
  app.listen port
  crypto = require 'crypto'

  app.post '/gitsum', (req, res) ->
    commit = req.headers.commit
    console.log 'verifying commit '+commit+'...'
    exec 'git show '+commit, (err, stdout, stderr) ->
      temp_array = stdout.trim().split('\n')
      count = 0;
      for line in temp_array
        if ~line.indexOf 'new file mode'
          prev = temp_array[count-1]
          if ~prev.indexOf 'gitsum/'
            addition = prev.split '/'
            file = addition[addition.length-1]
            exec '[ -f ./gitsum_tokens/'+file+' ] && echo "1" || echo "0"', (err, stdout, stderr) ->
              if stdout.trim() == '1'
                console.log 'commit verified!'
                exec 'rm -rf ./gitsum_tokens', (err, stdout, stderr) ->
                  console.log 'cherry-picking commit '+commit+'...'
                  exec 'git cherry-pick '+commit, (err, stdout, stderr) ->
                    console.log 'done!'
                    res.send 'hi'
        count++
     
  app.get '/gitsum', (req, res) ->
    current_date = (new Date()).valueOf().toString()
    random = Math.random().toString()
    shake = ['g','i','t','s','u','m']
    ind = 0
    for letter in shake
      if (Math.floor(Math.random() * 2) + 1) == 1
        shake[ind] = letter.toLowerCase()
      else
        shake[ind] = letter.toUpperCase()
      ind++

    shake = shake.join ''
    mix = [random, shake, current_date]
    i = mix.length - 1

    while i > 0
      j = Math.floor(Math.random() * (i + 1))
      temp = mix[i]
      mix[i] = mix[j]
      mix[j] = temp
      i--

    final = mix.join ''
    hash = crypto.createHash('sha1').update(final).digest('hex')

    file_name = shake + '.' + hash
    
    x_ip = req.headers['x-forwarded-for']
    if not x_ip
      x_ip = req.connection.remoteAddress

    console.log '\ntoken: '+file_name+' sent to '+x_ip

    exec 'rm -rf ./gitsum_tokens', (err, stdout, stderr) ->
      exec 'mkdir ./gitsum_tokens', (err, stdout, stderr) ->
        exec 'touch ./gitsum_tokens/'+file_name, (err, stdout, stderr) ->
          res.send file_name


else if mode in push_commands and arg3
  remote_server = arg3

  if arg4 in message_switch
    if arg5
      message = arg5
    else 
      console.log "warning: please include a message when using -m option"

  http = require 'http'

  options =
    host: remote_server
    port: 3013
    path: '/gitsum'
    method: 'GET'

  reques = http.request options, (response) ->
    str = ''

    response.on 'data', (chunk) ->
      str += chunk

    response.on 'end', ->
      str = str.trim()
      temp = str.split('.')
      phrase = temp[0]
      secret = temp[1]

      console.log 'token received\n:-------------------------------------------------:\n: '+str+' :'
      console.log ':-------------------------------------------------:'
      console.log 'overwriting ./gitsum'

      exec 'rm -rf ./gitsum', (err, stdout, stderr) ->
        exec 'git rm ./gitsum/*', (err, stdout, stderr) ->
          exec 'mkdir ./gitsum', (err, stdout, stderr) ->
            console.log 'creating token file ./gitsum/'+str
            exec 'touch ./gitsum/'+str, (err, stdout, stderr) ->
              console.log 'adding all files'
              exec 'git add *', (err, stdout, stderr) ->
                console.log 'commiting with message "'+message+'"'
                exec 'git commit -m "'+message+'"', (err, stdout, stderr) ->
                  exec 'git rev-parse --abbrev-ref HEAD', (err, stdout, stderr) ->
                    branch = stdout.trim()
                    console.log 'pushing to '+remote+' '+branch
                    process.stdout.write 'deploying to '+remote_server+' '
                    interval = setInterval(()->
                      process.stdout.write '-'
                    ,400)
                    exec 'git push '+remote+' '+branch, (err, stdout, stderr) ->
                      exec 'git log -1 --format="%H"', (err, stdout, stderr) ->
                        commit = stdout.trim()

                        options =
                          host: remote_server
                          port: 3013
                          path: '/gitsum'
                          method: 'POST'
                          headers: {'commit': commit}

                        reques = http.request options, (response) ->
                          clearInterval interval
                          process.stdout.write '> done!\n'
                          console.log '       _~'
                          console.log '    _~ )_)_~'
                          console.log '    )_))_))_)'
                          console.log '    _!__!__!__'
                          console.log '    \\ '+phrase+' /\n'
                          process.exit(code=0)


                        reques.write('')
                        reques.end() 

  console.log 'requesting token from '+remote_server
  reques.write('')
  reques.end() 

else if mode in push_commands
  console.log '\nand where were you trying to push to, exactly?'
  console.log 'try something like "gitsum push mysite.com" or "gitsum push 67.195.160.76"\n'
else
  console.log help