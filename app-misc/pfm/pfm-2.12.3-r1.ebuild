# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Terminal-based file manager written in Perl"
HOMEPAGE="https://p-f-m.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/p-f-m/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~s390 x86"

BDEPEND="
	>=dev-perl/File-Stat-Bits-0.190.0
	>=dev-perl/HTML-Parser-3.590.0
	>=dev-perl/libwww-perl-5.827.0
	>=dev-perl/Term-ReadLine-Gnu-1.160.0
	>=dev-perl/Term-Screen-1.30.0
	>=dev-perl/Term-ScreenColor-1.200.0
	>=virtual/perl-File-Temp-0.220.0
	>=virtual/perl-Module-Load-0.160.0
"
RDEPEND="
	${BDEPEND}
"
