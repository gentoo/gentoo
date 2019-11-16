# For headword lines, advance twice to (potentially) find the symbol definition
# -- the intermediate line is filler -- and then, if it does show the symbol,
# strip the label and append it to the previously-stored name, removing the
# line break
/^%h/{h;n;n;s/Symbol: //;t j;b;: j;x;G;s/\n/ /}
# However, that results in duplicated headers (i.e. the "Symbol:" line gets
# replaced rather than the "%h"), so go back through and, for any headword
# followed by filler followed by another headword, simplify it back down
/^%h/{N;N;s/%h.*\n%d\n\(%h.*\)/\1\n%d/}
