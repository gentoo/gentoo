# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HACHI
DIST_VERSION=0.06

inherit perl-module

DESCRIPTION="Network awareness and extensions for MogileFS::Server"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-perl/Net-Netmask
	dev-perl/Net-Patricia
	>=dev-perl/MogileFS-Server-2.580.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
