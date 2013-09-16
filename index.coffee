#! env coffee

ERROR_INVALID_SCRIPT  = 1
ERROR_READING_INPUT   = 2
ERROR_SCRIPT_FAILED   = 3
ERROR_WRITING_OUTPUT  = 4

program = require 'commander'
fs      = require 'fs'
jquery  = require 'jquery'
coffee  = require 'coffee-script'

program
  .version('0.1.0')
  .usage('[options] <script> <input file> <output file>')
  .parse(process.argv)

userScript  = program.args.shift()
input       = program.args.shift()
output      = program.args.shift() or input

if !userScript || !input || !output
  program.help()

fs.readFile userScript, (err, data) ->
  if err
    console.error 'Error reading script.\n', err

  # Compiles to JS to later on add a wrapper function that receives the jQuery object
  userScript = coffee.compile data.toString(), {bare: true}
  userScript = "(function f ($) {#{userScript}})"


fs.readFile input, (err, data) ->
  if err
    console.error 'Error reading input file.\n', err
    process.exit ERROR_READING_INPUT

  $ = (jquery.create())(data.toString())

  try
    eval(userScript)($)

  catch exception
    console.log 'Script error.\n', exception
    process.exit ERROR_SCRIPT_FAILED

  fs.writeFile output, $[0].outerHTML, (err) ->
    if err
      console.error 'Error writing to output file.\n', err
      process.exit ERROR_WRITING_OUTPUT


