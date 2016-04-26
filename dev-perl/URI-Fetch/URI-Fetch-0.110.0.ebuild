# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Smart URI fetching/caching"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-ErrorHandler
	dev-perl/libwww-perl
	virtual/perl-Storable
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Test-Simple
	)
"

src_test() {
	local my_test_control="${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}"

	if ! has 'network' ${my_test_control}; then
		einfo "Removing networking-required files"
		perl_rm_files t/{01-fetch,02-freezethaw}.t
	fi
	perl-module_src_test
}
