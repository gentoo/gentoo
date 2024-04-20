# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MUIR
DIST_VERSION=2014.01
DIST_SECTION=modules
inherit perl-module

DESCRIPTION="flock() wrapper.  Auto-create locks"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/Data-Structure-Util
	>=dev-perl/IO-Event-0.812.0
	dev-perl/Event
	virtual/perl-Time-HiRes
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/File-Slurp
		dev-perl/Test-SharedFork
	)
"
