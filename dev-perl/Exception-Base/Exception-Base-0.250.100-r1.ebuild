# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DEXTER
DIST_VERSION=0.2501
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Error handling with exception class"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-perl/Module-Build"
BDEPEND="
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Unit-Lite-0.120.0
	)
"
