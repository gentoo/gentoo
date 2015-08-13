# Fixes Texinfo input to compile with Texinfo 5 or later
#
# Written by Sebastian Pipping <sebastian@pipping.org>
# Licensed under CC0 1.0 Universal Public Domain Dedication
# https://creativecommons.org/publicdomain/zero/1.0/
#
# Version 0_p20150813_p0418

BEGIN {
	inside_deffn = 0
	inside_defmac = 0
	inside_defop = 0
	inside_deftp = 0
	inside_defun = 0
}

/^@deffn / {
	if (inside_deffn) {
		print "@end deffn"
	}
	inside_deffn = 1
}

/^@deffnx / {
	if (inside_deffn) {
		print "@end deffn"
	}
	sub(/^@deffnx/, "@deffn")
	inside_deffn = 1
}

/^@defmac / {
	if (inside_defmac) {
		print "@end defmac"
	}
	inside_defmac = 1
}

/^@defmacx / {
	if (inside_defmac) {
		print "@end defmac"
	}
	sub(/^@defmacx/, "@defmac")
	inside_defmac = 1
}

/^@defop / {
	if (inside_defop) {
		print "@end defop"
	}
	inside_defop = 1
}

/^@defopx / {
	if (inside_defop) {
		print "@end defop"
	}
	sub(/^@defopx/, "@defop")
	inside_defop = 1
}

/^@deftp / {
	if (inside_deftp) {
		print "@end deftp"
	}
	inside_deftp = 1
}

/^@deftpx / {
	if (inside_deftp) {
		print "@end deftp"
	}
	sub(/^@deftpx/, "@deftp")
	inside_deftp = 1
}

/^@defun / {
	if (inside_defun) {
		print "@end defun"
	}
	inside_defun = 1
}

/^@defunx / {
	if (inside_defun) {
		print "@end defun"
	}
	sub(/^@defunx/, "@defun")
	inside_defun = 1
}

/^@end deffn/ {
	inside_deffn = 0
}

/^@end defmac/ {
	inside_defmac = 0
}

/^@end defop/ {
	inside_defop = 0
}

/^@end deftp/ {
	inside_deftp = 0
}

/^@end defun/ {
	inside_defun = 0
}

/^@subsubsection/ {
	if (inside_deffn) {
		print "@end deffn"
		print $0
		print "@deffn {Dummy} Dummy"
		next
	}
}

{
	print
}
