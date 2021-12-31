# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JUERD
DIST_VERSION=1.35
inherit perl-module

DESCRIPTION="Very complete easy-to-use OO interface to DBI"

# Upstream says "Any OSI approved license from https://opensource.org/licenses/alphabetical"
LICENSE="|| ( AFL-3.0 AGPL-3 APL-1.0 Apache-2.0 BSD-2 Boost-1.0 CDDL CPAL-1.0
	EPL-1.0 ECL-2.0 EUPL-1.1 GPL-2 GPL-3 LGPL-2.1 LGPL-3 HPND IBM IPAfont ISC
	LPPL-1.3c 9base MIT MPL-2.0 NOSA nethack PHP-3 POSTGRESQL PYTHON CNRI
	QPL-1.0 OFL-1.1 Sleepycat Watcom-1.0 W3C wxWinLL-3 ZLIB libpng
)"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/DBI-1.210.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( !minimal? (
		>=dev-perl/DBD-SQLite-1.0.0
	) )
"
src_test() {
	perl_rm_files "t/pod.t"
	perl-module_src_test
}
