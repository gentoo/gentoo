# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SULLR
DIST_VERSION=2.086
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Nearly transparent SSL encapsulation for IO::Socket::INET"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="idn"

RDEPEND="
	dev-perl/Mozilla-CA
	>=dev-perl/Net-SSLeay-1.460.0
	virtual/perl-Scalar-List-Utils
	idn? (
		|| (
			>=dev-perl/URI-1.50
			dev-perl/Net-LibIDN
			dev-perl/Net-IDN-Encode
		)
	)"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

mydoc=("docs/debugging.txt")
