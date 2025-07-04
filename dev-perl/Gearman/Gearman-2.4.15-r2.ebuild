# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PALIK
DIST_VERSION=2.004.015
inherit perl-module

DESCRIPTION="Gearman distributed job system, client and worker libraries"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-perl/IO-Socket-SSL
	dev-perl/List-MoreUtils
	dev-perl/String-CRC32
	>=virtual/perl-version-0.770.0
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/File-Which
		>=dev-perl/Proc-Guard-0.70.0
		dev-perl/Test-Exception
		>=dev-perl/Test-TCP-2.170.0
		dev-perl/Test-Timer
	)
"

mydoc="CHANGES HACKING TODO"
