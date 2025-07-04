# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SEWI
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Format a bytecount and make it human readable"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
"

PATCHES=(
	"${FILESDIR}/${PN}-0.06-no-dot-inc.patch"
)
