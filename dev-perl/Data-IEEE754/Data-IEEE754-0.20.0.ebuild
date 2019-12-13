# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Pack and unpack big-endian IEEE754 floats and doubles"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Bits )"
