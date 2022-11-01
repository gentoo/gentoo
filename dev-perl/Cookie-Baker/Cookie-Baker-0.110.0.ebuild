# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Cookie string generator / parser"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="test +xs"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Exporter
	dev-perl/URI
	xs? ( >=dev-perl/Cookie-Baker-XS-0.110.0 )
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Time
	)
"
