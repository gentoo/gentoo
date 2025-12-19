# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Common Lisp"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

RDEPEND="
	|| (
		dev-lisp/sbcl
		dev-lisp/clisp
		dev-lisp/clozurecl
		dev-lisp/cmucl
		dev-lisp/ecl
		dev-lisp/gcl
		dev-lisp/abcl
	)"
