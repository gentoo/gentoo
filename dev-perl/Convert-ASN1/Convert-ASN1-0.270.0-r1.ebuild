# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GBARR
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="Standard en/decode of ASN.1 structures"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Math-BigInt-1.997.0
		>=virtual/perl-Test-Simple-0.900.0
	)
"
PATCHES=(
	"${FILESDIR}/${P}-perl-526.patch"
	"${FILESDIR}/${PN}-0.270.0-CVE-2013-7488.patch"
)
