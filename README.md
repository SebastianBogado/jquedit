jquedit
=======

HTML editor that uses jQuery syntax.

Usage
-----

    jquedit <script> <input file> [<output file>]

Summary
-------

jquedit will read the input HTML file, pass the document to the edition script
and write to the output HTML file after the script has made its changes to the
doc.

The script file must export a function as a node module. The said function will
receive a jQuery wrapped version of the input document by means of which the
document can be modified.

Example script
--------------

The following script will remove the HTML class "my-class" from every element in
the document which has it set.

    module.exports = ($) ->
        $('.my-class').removeClass('my-class');


