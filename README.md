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


Example script
--------------

The following script will remove the HTML class "my-class" from every element in
the document which has it set.

    $('.my-class').removeClass('my-class');


