# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=HAYASHI
DIST_VERSION=1.42
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Perl extension for the GNU Readline/History Library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=sys-libs/readline-6.2:0="
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
