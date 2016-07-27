# Import modules
open   = require 'open'
prompt = require 'prompt'
google = require 'google'
chalk  = require 'chalk'

# Configure modules
error = chalk.red
primary = chalk.blue
secondary = chalk.green
tertiary = chalk.grey
prompt.message = ''
prompt.delimiter = ''

googleColors = ->
  colored = []
  gcolors = [
    chalk.blue
    chalk.red
    chalk.yellow
    chalk.blue
    chalk.green
    chalk.red
  ]
  colored = (gcolors[i % gcolors.length](arguments[i]) for i in [0 .. arguments.length - 1])
  colored

options = ->
  op =
    query: ''
    lucky: false
    chrome: false
    results: 10
  skip = false
  # Check arguments
  process.argv.forEach (val, index, array) ->
    # Skip argument if necessary
    if skip
      skip = false
      return

    # Check for flags
    if val.indexOf('-c') == 0 or val.indexOf('--chrome') == 0
      op.chrome = true
      return
    if val.indexOf('-l') == 0 or val.indexOf('--lucky') == 0
      op.lucky = true
      return
    if val.indexOf('-r') == 0 or val.indexOf('--results') == 0
      op.results = array[index + 1]
      # Grab the next argument
      skip = true
      # Skip next argument
      return

    # If we're still looking at this arg, add it to query
    if index > 1
      op.query = op.query + ' ' + val
  op

# Prepare modules
prompt.start()
options = options()
google.resultsPerPage = options.results

schema = properties: selection:
  pattern: /^\d+$/
  message: 'Selection must be a number'
  description: chalk.white('Link number: ')
  required: true

links = []

if !options.query
  console.error error('No query provided')
  process.exit 1

google options.query, (err, res) ->
  if err
    console.error error(err)
    process.exit 1

  if options.chrome
    # Open search page in browser
    open res.url
  else
    console.log googleColors('G', 'o', 'o', 'g', 'l', 'e').join('') + ' Search results for ' + options.query

    # Print links to console
    for i in [0 .. res.links.length]
      link = res.links[i]
      console.log tertiary(' [') + primary(i + 1) + tertiary('] :: ') + secondary(link.title) + tertiary('\n\u0009 => ') + tertiary(link.href)
      links.push res.links[i].href

    # If you're feeling lucky, open first link
    if options.lucky
      console.log 'Opening ' + links[0]
      open links[0]
      process.exit 0

    # Otherwise, prompt for selection
    (getSelection = ->
      prompt.get schema, (err, res) ->
        if err
          console.error error(err)
          process.exit 2
        # Open selection in browser
        if res.selection < links.length
          open links[res.selection - 1]
        else
          console.error error('Selection is out of bounds')
          getSelection()
      )()
