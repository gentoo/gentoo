# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Common Lisp"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

RDEPEND="
	|| (
		dev-lisp/sbcl
		dev-lisp/clisp
		dev-lisp/clozurecl
		dev-lisp/cmucl
		dev-lisp/ecls
		dev-lisp/gcl
		dev-lisp/abcl
	)"
