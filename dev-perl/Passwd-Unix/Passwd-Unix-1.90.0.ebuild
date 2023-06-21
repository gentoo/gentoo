# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STRZELEC
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="Access to standard unix passwd files"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Crypt-Password
	dev-perl/Exporter-Tiny
	>=virtual/perl-IO-Compress-2.15.0
	dev-perl/Path-Tiny
	dev-perl/Tie-Array-CSV
"
# Technically works w/ older MM but has a bunch of conditions to try make it work
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.630.0
"
