# Trim the header/footer out; saved to another file for reference
/^The Jargon Lexicon/,/:(Lexicon Entries End Here):/!{
	w jargon.doc
	d
}
# To allow for consistency in scripts, convert everything that's been indented
# beyond the start of headwords into a single tab
s/^    \s*/\t/
# Some versions indent the headwords exactly three spaces; they shouldn't
s/^   //
# Delete letter separators and the following blank line
/^= . =/,/^$/d
# Join any non-indented lines with the following paragraph content, until the
# first line without significant content
/^\S/{: l;N;s/\n *\(.\)/ \1/g;t l}
# Fix the tabs that randomly end up finishing sentences
s/\([^\t]\)\t/\1  /g
# Remove any spaces after the headwords, as those would otherwise show up in
# the dictionary output
s/^\(:[^:]*:\)\s*/\1/
# Attempt to detect alternate sense numbers which have been joined into the
# middle of a paragraph; note that even without the previous command, these
# still occur in the original file
s/\([^A-Za-z ]\) \+\([2-9][0-9]\?\|1[0-9]\)\.\( \+\|$\)/\1\n\n\2. /g
# Any alternate senses which /do/ appear at the beginning of a line also need
# to be fixed
s/^\([2-9][0-9]\?\|1[0-9]\)\.\( \+\|$\)/\n\1. /g
