# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ESAYM
DIST_VERSION=1.93
inherit perl-module

DESCRIPTION="Connect to a local Clam Anti-Virus clamd service and send commands"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="app-antivirus/clamav"
DEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

DIST_TEST=skip
# tests require clamav to be configured, which we can't guarantee here
