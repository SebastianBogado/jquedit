#! env coffee

ERROR_INVALID_SCRIPT  = 1
ERROR_READING_INPUT   = 2
ERROR_SCRIPT_FAILED   = 3
ERROR_WRITING_OUTPUT  = 4

program = require 'commander'
fs      = require 'fs'
jquery  = require 'jquery'

program
  .version('0.0.1')
  .usage('[options] <full/path/to/script> <input file> <output file>')
  .parse(process.argv)
  
userScript  = program.args.shift()
input       = program.args.shift()
output      = program.args.shift() or input

if !userScript || !input || !output
  program.help()

userScript = require userScript

if typeof userScript isnt 'function'
  console.error 'Invalid script.'
  process.exit ERROR_INVALID_SCRIPT

fs.readFile input, (err, data) ->
  if err
    console.error 'Error reading input file.\n', err
    process.exit ERROR_READING_INPUT
  
  $ = (jquery.create())(data.toString())
  
  try
    userScript $
  catch exception
    console.log 'Script error.\n', exception
    process.exit ERROR_SCRIPT_FAILED
  
  fs.writeFile output, $[0].outerHTML, (err) ->
    if err
      console.error 'Error writing to output file.\n', err
      process.exit ERROR_WRITING_OUTPUT


