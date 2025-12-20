# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CORNELIS
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Merge nested Perl data structures"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/Clone-0.220.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.440.0
	)
"

# Its a silly EUMM Shim
# and it doesn't work anyway without '.' in @INC
PREFER_BUILDPL=no
