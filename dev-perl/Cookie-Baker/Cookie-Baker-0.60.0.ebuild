# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KAZEBURO
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Cookie string generator / parser"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
	dev-perl/URI
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Time
	)
"

SRC_TEST="do parallel"
