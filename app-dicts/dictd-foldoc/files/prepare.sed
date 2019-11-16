# For any empty lines, if the next line contains non-indented text (i.e. is a
# headword), remove both that empty line and the one following the headword;
# this retains line breaks between definition paragraphs
/^$/{N;s/\n\([^\t]\+\)/\1/g;t j;b;: j;h;n;d}
