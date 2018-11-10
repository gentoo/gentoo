# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=WBRASWELL
DIST_VERSION=1.21
DIST_EXAMPLES=( "Calc.yp" "YappParse.yp" )
inherit perl-module

DESCRIPTION="Compiles yacc-like LALR grammars to generate Perl OO parser modules"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="!=net-fs/samba-4*"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
mydoc="docs/*"
