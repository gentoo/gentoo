# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=1.26
inherit perl-module toolchain-funcs

DESCRIPTION="Simple interface to F77 libs"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~m68k ~mips ppc ppc64 ~s390 ~sparc x86"

RDEPEND="
	dev-perl/File-Which
	virtual/fortran
"
BDEPEND="${RDEPEND}"
