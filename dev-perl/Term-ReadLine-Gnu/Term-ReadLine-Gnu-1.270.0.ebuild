# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HAYASHI
MODULE_VERSION=1.27
inherit perl-module

DESCRIPTION="GNU Readline XS library wrapper"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=sys-libs/readline-6.2:0="
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

SRC_TEST="do parallel"
