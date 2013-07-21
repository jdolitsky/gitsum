      return exec('git pull', function(err, stdout, stderr) {
        return exec('git show ' + commit, function(err, stdout, stderr) {
          var addition, count, file, line, prev, temp_array, _i, _len, _results;
          temp_array = stdout.trim().split('\n');
          count = 0;
          _results = [];
          for (_i = 0, _len = temp_array.length; _i < _len; _i++) {
            line = temp_array[_i];
            if (~line.indexOf('new file mode')) {
              prev = temp_array[count - 1];
              if (prev && ~prev.indexOf('gitsum_token/')) {
                addition = prev.split('/');
                file = addition[addition.length - 1];
                exec('[ -f ./gitsum_server/' + file + ' ] && echo "1" || echo "0"', function(err, stdout, stderr) {
                  if (stdout.trim() === '1') {
                    console.log('commit verified!');
                    return exec('rm -rf ./gitsum_server', function(err, stdout, stderr) {
                      console.log('deploying...');
                      return exec('git reset --hard ' + commit, function(err, stdout, stderr) {
                        console.log('done!');
                        return res.send('1');
                      });
                  }
                });
              }
            _results.push(count++);
          return _results;
        });
      return exec('rm -rf ./gitsum_server', function(err, stdout, stderr) {
        return exec('mkdir ./gitsum_server', function(err, stdout, stderr) {
          return exec('touch ./gitsum_server/' + file_name, function(err, stdout, stderr) {
        console.log('overwriting ./gitsum_token');
        return exec('rm -rf ./gitsum_token', function(err, stdout, stderr) {
          return exec('git rm ./gitsum_token/*', function(err, stdout, stderr) {
            return exec('mkdir ./gitsum_token', function(err, stdout, stderr) {
              console.log('creating token file ./gitsum_token/' + str);
              return exec('touch ./gitsum_token/' + str, function(err, stdout, stderr) {