# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SNOWHARE
DIST_VERSION=1.11
inherit perl-module

DESCRIPTION="Conversions to and from arbitrary character sets and UTF8"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="dev-perl/Unicode-Map
	dev-perl/Unicode-Map8
	dev-perl/Unicode-String
	dev-perl/Jcode"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

PERL_RM_FILES=("t/99_pod.t" "t/98_pod_coverage.t" "t/97_distribution.t")
