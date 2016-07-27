# google-client

Simple implementation of Google search for command line.

This is a third party application not in affiliation with Google.

## Disclaimer

This is currently in an early access build.
As such, behavior may not always be as expected.
Please open an issue if you experience any bugs.

## Installation

```bash
$ npm install google-client -g
```

Run the command line:

```bash
$ google [options] query
```

## Flags

We can use the following arguments to control the search:

| Flag           | Description                                    | Default |
|----------------|------------------------------------------------|------:|
|  -c / --chrome | Open in search page in browser                 | false |
|  -l / --lucky  | (I'm feeling lucky) open first link in browser | false |
|  -r / --results [RESULTS] | Specify number of results | 10 |
| -x / --exclude [ITEM] | Exclude item from search results (can be used more than once) | none |
| -s / --site [SITE] | Filter by results found from this site | none |

## Examples usage

```bash
# Regular search queries
$ google node.js best practices

# I'm Feeling Lucky
$ google npm -l

# Open search results page
$ google -c Electron Angular

# Specify number of results
$ google -r 5 github latest broadcasts

# Exclude results
$ google jaguar speed -x car -x motor

# Specify site
$ google josh hawkins -s github.com

# You can even use Google's other built-in operators ($x for shopping prices)
$ google -s amazon.com oculus rift $600
```

## Changelog

 - **0.0.4** - Add site & exclude flags and colors
 - **0.0.3** - Corrected query parameter
 - **0.0.2** - Minor text fixes
 - **0.0.1** - Initial program
