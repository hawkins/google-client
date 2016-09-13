# Import modules
open   = require 'opn'
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
  if arguments[1]?
    colored = (gcolors[i % gcolors.length](arguments[i]) for i in [0 .. arguments.length - 1])
  else
    colored = (gcolors[i % gcolors.length](arguments[0][i]) for i in [0 .. arguments[0].length - 1])
  colored.join ''

# TODO: Add more operators from: https://support.google.com/websearch/answer/2466433?hl=en
options = ->
  op =
    query: ''
    lucky: false
    chrome: false
    results: 10
    excludes: []
    site: ''
  skip = false
  # Check arguments
  process.argv.forEach (val, index, array) ->
    # Skip argument if necessary
    if skip > 0
      --skip
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
      skip = 1
      return
    if val.indexOf('-s') == 0 or val.indexOf('--site') == 0
      op.site = array[index + 1]
      skip = 1
      return
    if val.indexOf('-x') == 0 or val.indexOf('--exclude') == 0
      op.excludes.push array[index + 1]
      skip = 1
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
  pattern: /^\d(\s+\d\s*)*$/
  message: 'Selection must be one or more numbers'
  description: chalk.white('Link number: ')
  required: true

links = []

if !options.query
  console.error error 'No query provided'
  process.exit 1

# Expand on query
query = options.query
if options.excludes.length > 0
  query = query + (' -' + options.excludes[i] for i in [0 .. options.excludes.length - 1]).join('')
if options.site
  query = query + " site:#{options.site}"

google query, (err, res) ->
  if err
    console.error error err
    process.exit 1

  if options.chrome
    open res.url
  else
    if res.links.length > 0
      console.log googleColors('Google') + ' Search results for' + primary(query)
    else
      console.error googleColors('Google') + error(' Search was unable to find anything!')
      process.exit 3

    # Print links to console
    limit = if res.links.length > options.results then options.results - 1 else res.links.length - 1
    for i in [0 .. limit]
      link = res.links[i]
      try
        console.log tertiary(' [') + primary(i + 1) + tertiary('] :: ') + secondary(link.title) + tertiary('\n\u0009 => ') + tertiary(link.href)
      catch err
        console.error error err
      links.push res.links[i].href

    # If you're feeling lucky, open first link
    if options.lucky
      console.log "Opening #{links[0]}"
      return open links[0]

    # Otherwise, prompt for selection
    (getSelection = ->
      prompt.get schema, (err, res) ->
        if err
          console.error error err
          process.exit 2

        selections = res.selection.split(/\s+/g)
        selections.forEach (val, index, array) ->
          # Open selection in browser
          if selections[index] <= links.length
            open links[selections[index] - 1]
          else
            console.error error 'Selection is out of bounds'
            getSelection()
      )()
