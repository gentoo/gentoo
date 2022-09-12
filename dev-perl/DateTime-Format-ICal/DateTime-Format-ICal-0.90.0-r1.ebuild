# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Parse and format iCal datetime and duration strings"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/DateTime-0.170.0
	>=dev-perl/DateTime-Event-ICal-0.30.0
	>=dev-perl/DateTime-Set-0.100.0
	>=dev-perl/DateTime-TimeZone-0.220.0
	>=dev-perl/Params-Validate-0.590.0
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"
