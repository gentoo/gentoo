# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DSHULTZ
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="OOP interface to the FreeDB database"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/CDDB-File-1.10.0
	>=virtual/perl-File-Temp-0.50.0
	virtual/perl-IO
	dev-perl/Moo
	>=virtual/perl-libnet-2.120.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Most
	)
"
src_test() {
	local my_test_control;
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if has network ${my_test_control} ; then
		export HAVE_INTERNET=1
		perl_rm_files "t/16-get_local_disc_id.t" "t/17-get_local_disc_data.t"
	fi
	perl-module_src_test
}
