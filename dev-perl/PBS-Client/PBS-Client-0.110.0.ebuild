# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=KWMAK
DIST_SECTION=PBS/Client
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Perl interface to submit jobs to PBS (Portable Batch System)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/perl-Data-Dumper-2.121.0
	>=virtual/perl-File-Temp-0.140.0
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
