# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SCOTTW
DIST_VERSION=1.41
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Read/Write Vixie compatible crontab(5) files"
LICENSE="Artistic"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="virtual/perl-ExtUtils-MakeMaker"
