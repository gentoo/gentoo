# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JHOBLITT
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Parses Date::Parse compatible formats"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	>=dev-perl/DateTime-0.290.0
	>=dev-perl/DateTime-TimeZone-0.270.0
	dev-perl/TimeDate
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
"
