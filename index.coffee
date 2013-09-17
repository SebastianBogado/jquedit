#! env coffee

ERROR_INVALID_SCRIPT  = 1
ERROR_READING_INPUT   = 2
ERROR_SCRIPT_FAILED   = 3
ERROR_WRITING_OUTPUT  = 4

program = require 'commander'
fs      = require 'fs'
jquery  = require 'jquery'
coffee  = require 'coffee-script'
repl    = require 'repl'
jsdom = require 'jsdom'

program
  .version('0.1.1')
  .usage('[options] <input file> <output file>')
  .parse(process.argv)

input       = program.args.shift()
output      = program.args.shift() or input

if !input || !output
  program.help()

evalFn = (cmd, context, filename, callback) ->
  return callback(null, cmd) if cmd is '(\n)'  # Horrible

  # Compiles to JS to later on add a wrapper function that receives the jQuery object
  userScript = coffee.compile cmd, {bare: true}
  userScript = "(function f ($) { return #{userScript}})"

  try
    eval(userScript)(context.$)
    result = ''  # jQuery object is too verbose to have it as the result

    fs.writeFile output, context.$[0].outerHTML, (err) ->
      if err
        console.error 'Error writing to output file.\n', err
        process.exit ERROR_WRITING_OUTPUT

  catch exception
    result = 'Script error.\n' + exception


  callback(null, result);



fs.readFile input, (err, data) ->
  if err
    console.error 'Error reading input file.\n', err
    process.exit ERROR_READING_INPUT

  jsdom.env
    html: data.toString()
    scripts: ['jquery.min.js']
    done: (err, window) ->
      # Start REPL
      repl.start(
        prompt: 'jQuedit> '
        eval: evalFn
      ).context.$ = window.jQuery


