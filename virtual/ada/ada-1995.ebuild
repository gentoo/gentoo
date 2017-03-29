# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Virtual for selecting an appropriate Ada compiler"
# Different versions of Ada compilers can and likely will be installed side by
# side
SLOT="1995"
KEYWORDS="amd64 ppc x86"

RDEPEND="|| (
	=dev-lang/gnat-gcc-4.2*
	=dev-lang/gnat-gcc-4.1*
	=dev-lang/gnat-gcc-3.4* )"
