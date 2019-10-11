# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for Fortran Compiler"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="openmp"

RDEPEND="
	|| (
		sys-devel/gcc[fortran,openmp?]
		sys-devel/gcc-apple[fortran,openmp?]
		dev-lang/ekopath
		dev-lang/ifc
		)"
