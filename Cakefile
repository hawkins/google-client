{exec} = require 'child_process'
fs = require 'fs'
task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
    shebang = "#!/usr/bin/env node"
    fs.writeFileSync('lib/index.js', [shebang, fs.readFileSync('lib/index.js')].join('\n'));
