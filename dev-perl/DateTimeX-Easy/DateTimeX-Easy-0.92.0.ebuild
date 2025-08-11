# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JJNAPIORK
DIST_VERSION=0.092
inherit perl-module

DESCRIPTION="Parse a date/time string using the best method available"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-perl/DateTime
	dev-perl/TimeDate
	dev-perl/DateTime-Format-Flexible
	dev-perl/DateTime-Format-ICal
	dev-perl/DateTime-Format-Natural
	>=dev-perl/DateTime-TimeZone-2.630.0
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Most
	)
"
