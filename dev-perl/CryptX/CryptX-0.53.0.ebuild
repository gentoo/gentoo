# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=MIK
DIST_VERSION=0.053
inherit perl-module

DESCRIPTION="Self-contained crypto toolkit"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test minimal"

RDEPEND="
	>=virtual/perl-Exporter-5.590.0
	!minimal? (
		|| ( dev-perl/Cpanel-JSON-XS dev-perl/JSON-XS virtual/perl-JSON-PP )
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		!minimal? (
			>=virtual/perl-Math-BigInt-1.999.715
			>=virtual/perl-Storable-2.0.0
		)
	)
"

src_test() {
	perl_rm_files t/003_all_pm_pod.t
	perl-module_src_test
}
