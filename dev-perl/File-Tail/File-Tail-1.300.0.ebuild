# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MGRABNAR
DIST_VERSION=1.3
inherit perl-module

DESCRIPTION="Perl extension for reading from continously updated files"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	>=virtual/perl-Time-HiRes-1.120.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

mydoc="ToDo"
