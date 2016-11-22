# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ROBIN
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="A generalisation of wantarray"

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~x86 ~ppc-aix"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
