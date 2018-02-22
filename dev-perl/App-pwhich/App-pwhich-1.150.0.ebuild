# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.15
inherit perl-module

DESCRIPTION="Perl-only 'which'"
SLOT="0"
KEYWORDS="~amd64 ~mips ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	>=dev-perl/File-Which-1.140.0
"
# Test2::V0 -> Test2-Suite-0.0.72
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Capture-Tiny
		>=dev-perl/Test2-Suite-0.0.72
		dev-perl/Test-Script
	)
"
