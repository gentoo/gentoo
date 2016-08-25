# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DWHEELER
DIST_VERSION=3.32
inherit perl-module

DESCRIPTION="Stream TAP from pgTAP test scripts"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	virtual/perl-Test-Harness
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.300.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
