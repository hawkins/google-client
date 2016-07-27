{exec} = require 'child_process'
fs = require 'fs'
task 'build', 'Build project from src/*.coffee to dist/*.js', ->
  exec 'coffee --compile --output dist/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
    shebang = "#!/usr/bin/env node"
    fs.writeFileSync('dist/index.js', [shebang, fs.readFileSync('dist/index.js')].join('\n'));
