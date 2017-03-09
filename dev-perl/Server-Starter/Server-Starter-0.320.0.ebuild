# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KAZUHO
MODULE_VERSION=0.32
inherit perl-module

DESCRIPTION="A superdaemon for hot-deploying server programs"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		dev-perl/Test-Requires
		dev-perl/Test-SharedFork
		>=dev-perl/Test-TCP-2.130.0
	)
"

SRC_TEST="do parallel"
