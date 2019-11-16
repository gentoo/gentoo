# Trim the header/footer out; saved to another file for reference
/^ *THE DEVIL'S DICTIONARY/,/^End of Project Gutenberg's The Devil's Dictionary/!{
	w COPYING.gutenberg
	d
}
# Indent anything that should not be a headword:
#   Headwords are typically capital letters, but some include the punctuation
#   and two have alternate names separated by "or"; we have to ignore anything
#   matching that, but so long as the first character after one of those is not
#   a comma, it's not beginning a definition.
s/^\([A-Zor .'?-]*[^,A-Zor .'?-]\)/ \1/
s/^.\..\./ &/
# Join any non-indented lines with the following paragraph content, until the
# first line without significant content
/^\S/{: l;N;s/\r\?\n *\(\S\)/ \1/g;t l}
# dictfmt doesn't actually check that the line starts in the first column for
# headwords, just for the presence of a comma; anything that should be inline
# text needs to be replaced temporarily (keep up-to-date with finalize.sed)
/^ /y/,/\a/
