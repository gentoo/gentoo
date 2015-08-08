# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-app

DESCRIPTION="A terminal-based file manager written in Perl"
HOMEPAGE="http://p-f-m.sourceforge.net/"
SRC_URI="mirror://sourceforge/p-f-m/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-lang/perl-5.8
	>=dev-perl/File-Stat-Bits-1.10.0
	>=dev-perl/HTML-Parser-3.59
	>=dev-perl/libwww-perl-5.827
	>=dev-perl/Term-ReadLine-Gnu-1.09
	>=dev-perl/Term-Screen-1.30.0
	>=dev-perl/Term-ScreenColor-1.130.0
	sys-libs/ncurses
	sys-libs/readline
	>=virtual/perl-File-Temp-0.22
	>=virtual/perl-Module-Load-0.16"
