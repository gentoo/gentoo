# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=COSIMO
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="Perl module for manipulating .po entries from GNU gettext"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-devel/gettext
	dev-perl/File-Slurp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
