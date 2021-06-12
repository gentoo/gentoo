# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETJ
DIST_VERSION=1.26
inherit perl-module toolchain-funcs

DESCRIPTION="Simple interface to F77 libs"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-perl/File-Which
	virtual/perl-Scalar-List-Utils
	virtual/perl-Text-ParseWords
	virtual/fortran
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
