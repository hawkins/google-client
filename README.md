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
$ google [OPTIONS] [QUERY]
```

## Flags

We can use the following arguments to control the search:

| Flag           | Description                                    |
|----------------|------------------------------------------------|
|  -c            | Open in search page in browser                 |
|  -l            | (I'm feeling lucky) open first link in browser |
|  -r [RESULTS]  | Specify number of results                      |

## Examples usage

```bash
$ google node.js best practices
$ google npm -l
$ google -r 5 github latest broadcasts
```

## Changelog

 - **0.0.3** - Corrected query parameter
 - **0.0.2** - Minor text fixes
 - **0.0.1** - Initial program
