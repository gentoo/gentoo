# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=BPGN
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION='A class for european VAT numbers validation'
LICENSE=" GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/HTTP-Message-1.0.0
	>=dev-perl/libwww-perl-1.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
