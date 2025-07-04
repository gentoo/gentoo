# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REHSACK
DIST_VERSION=0.06

inherit perl-module

DESCRIPTION="Provide the stuff missing in Hash::Util"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.900.0 )
"
