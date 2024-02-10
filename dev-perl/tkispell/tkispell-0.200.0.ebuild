# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ASB
DIST_VERSION=0.20
DIST_NAME=App-tkispell
inherit perl-module

DESCRIPTION="Perl/Tk user interface for ispell"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-text/aspell
	>=dev-perl/Tk-800.4.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=( "${FILESDIR}/tkispell-0.20-nowindows.patch" )
