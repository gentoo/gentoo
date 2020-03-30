# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for Common Lisp"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"

RDEPEND="|| ( dev-lisp/sbcl
	dev-lisp/clisp
	dev-lisp/clozurecl
	dev-lisp/cmucl
	dev-lisp/ecls
	dev-lisp/gcl
	dev-lisp/abcl )"
