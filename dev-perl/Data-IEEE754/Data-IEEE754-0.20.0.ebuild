# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Pack and unpack big-endian IEEE754 floats and doubles"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Bits
		>=virtual/perl-Test-Simple-0.960.0
	)
"
