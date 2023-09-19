# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DEXTER
DIST_VERSION=0.0401
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Convert simple warn into real exception object"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Exception-Base-0.210.0
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Assert-0.50.0
		>=dev-perl/Test-Unit-Lite-0.120.0
		virtual/perl-parent
	)
"
