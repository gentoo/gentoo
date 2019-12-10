# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DANBORN
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Query a Google SafeBrowsing table"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/URI
	>=virtual/perl-Math-BigInt-1.87
	virtual/perl-DB_File
	|| (
		virtual/perl-Math-BigInt-FastCalc
		dev-perl/Math-BigInt-GMP
	)"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

PERL_RM_FILES=( "t/pod.t" )
