# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GUIMARD
DIST_VERSION=0.28
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Class to easily create a mail server"

# Some files Artistic-2
LICENSE="LGPL-2.1+ Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/IO-Socket-SSL-1.831.0
	virtual/perl-libnet
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Most )
"
