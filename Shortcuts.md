# Commands

This is a list of useful commands to use when using nvim.

* Capital W: This will jump to the next "word". It stops at the start of the word. Here we understand a word as something that is not a white space.
* Capital E: This will jump to the next "word". It stops at the end of the word.
* Capital B: This will jump to the previous "word". It stops at the start of the word.
* "/<text>": Search for the next ocurrence of the <text>
* Ctrl + D / Ctrl + U: Jumps bigger forward and backwards in the file.
* Ctrl + { / Ctrl + }: Jumps to the next {\r / Jumps to the next }\r -> This can be useful when selecting blocks of code.

* cib: Change in bracket -> Allows you to replace whatever it is contained between 2 brackekets.
* vib: Select in bracket -> Allows you to select whatever it is contained between 2 brackekets.
* cab: Removes bracket's content includign brackets.

* ci{: Change in curly bracket -> Allows you to replace whatever it is contained between 2 curly brackekets.
* vi{: Select in curly bracket -> Allows you to select whatever it is contained between 2 curly brackekets.
* ca{: Removes curly bracket's content includign curly brackets.

* ca<: Removes <'s content includign < >.

You do not need to be inside () or {}

* cw: Change whatever word is in front of the cursor.
* ciw: Change whatever word the cursor is currently in.

* ve: Select whatever word is in front of the cursor.
* viw: Change whatever word the cursor is currently in.

With nvim-surround
* cs<current-surruound><new-surround>: Replace current surround with a new one.
* cs'": Replace current surround with a new one.
* S): Add currly brackets to the selected text. (Always use the end ')')
* S}: Add currly brackets to the selected text. (Always use the end '}')

* :map: List all key mappings
* :map <lhs>: List the key mpaapings for the key sequences starting with {lhs}

* :marks: Show the list of current marks
* :Telescope nmarks: Show the list of current marks. (Allows you to see the mark.)


## Snippets
