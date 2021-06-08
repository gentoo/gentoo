# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RSAVAGE
DIST_A_EXT=tgz
DIST_VERSION=1.31
inherit perl-module

DESCRIPTION="(Super)class for representing nodes in a tree"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/File-Slurp-Tiny-0.3.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.1.14
		>=virtual/perl-File-Spec-3.400.0
		>=virtual/perl-File-Temp-0.190.0
	)
"
