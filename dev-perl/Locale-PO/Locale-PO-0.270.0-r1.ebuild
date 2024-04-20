# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=COSIMO
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="Perl module for manipulating .po entries from GNU gettext"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ppc ppc64 ~s390 sparc x86"

RDEPEND="
	sys-devel/gettext
	dev-perl/File-Slurp
"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
