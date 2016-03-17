# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MUIR
MODULE_VERSION=2014.01
MODULE_SECTION=modules
inherit perl-module

DESCRIPTION="flock() wrapper.  Auto-create locks"

SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 ~sparc x86"
IUSE="test"

SRC_TEST="do"

RDEPEND="
	dev-perl/Data-Structure-Util
	>=dev-perl/IO-Event-0.812.0
	dev-perl/AnyEvent
	dev-perl/Event
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/File-Slurp
	test? ( dev-perl/Test-SharedFork )
"
