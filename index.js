#!/usr/bin/env node

'use strict';

var open = require('open');
var prompt = require('prompt');
var google = require('google');



function options() {
  var op = {
    query: '',
    lucky: false,
    chrome: false,
    results: 11
  };

  var skip = false;

  // Check arguments
  process.argv.forEach(function (val, index, array) {
    // Skip argument if necessary
    if (skip) {
      skip = false;
      return;
    }

    // Check for flags
    if (val.indexOf('-c') === 0 || val.indexOf('--chrome') === 0) {
      op.chrome = true;
      return;
    }
    if (val.indexOf('-l') === 0 || val.indexOf('--lucky') === 0) {
      op.lucky = true;
      return;
    }
    if (val.indexOf('-r') === 0 || val.indexOf('--results') === 0) {
      op.results = array[index + 1]; // Grab the next argument
      skip = true; // Skip next argument
      return;
    }

    // If we're still looking at this arg, add it to query
    if (index > 1) op.query = op.query + ' ' + val;
  });

  return op;
}



prompt.start();

var options = options();
google.resultsPerPage = options.results;
var schema = {
  properties: {
    selection: {
      pattern: /^\d+$/,
      message: 'Selection must be only a number',
      required: true
    }
  }
};
var links = [];

if (!options.query) {
  console.error('No query provided');
  process.exit(1);
}

google(options.query, function (err, res){
  if (err) {
    console.error(err);
    process.exit(1);
  }

  if (options.chrome) {
    // Open search page in browser
    open(res.url);
  } else {
    // Print links to console
    for (var i = 0; i < res.links.length; ++i) {
      var link = res.links[i];
      console.log("[" + (i + 1) + "] :: " + link.title + '\n => ' + link.href);
      links.push(res.links[i].href);
    }

    // If you're feeling lucky, open first link
    if (options.lucky) {
      console.log('Opening ' + links[0]);
      open(links[0]);
    } else {
      // Otherwise, prompt for selection
      prompt.get(schema, function (err, res) {
        // Open selection in browser
        if (err) {
          console.error(err);
          process.exit(2);
        } else {
          open(links[res.selection - 1]);
          // TODO: Add error checking to ensure selection is not out of bounds
          // TODO: Allow to select next/previous page with 'n' or 'p'
          //   -> if (res.next) res.next();
        }
      });
    }
  }
});
