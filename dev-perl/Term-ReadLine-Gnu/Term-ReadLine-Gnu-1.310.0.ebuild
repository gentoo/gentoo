# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=HAYASHI
DIST_VERSION=1.31
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="GNU Readline XS library wrapper"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=sys-libs/readline-6.2:0="
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
