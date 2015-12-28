# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=POTYL
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Simple DNS resolver with caching"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/AnyEvent
"
DEPEND="${RDEPEND}
	virtual/perl-File-Spec
	>=dev-perl/Module-Build-0.400.0
	test? ( virtual/perl-Test-Simple )
"
