# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SULLR
DIST_VERSION=2.095
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Nearly transparent SSL encapsulation for IO::Socket::INET"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="idn"

RDEPEND="
	>=dev-perl/Net-SSLeay-1.460.0
	idn? (
		|| (
			>=dev-perl/URI-1.50
			dev-perl/Net-LibIDN
			dev-perl/Net-IDN-Encode
		)
	)
"

mydoc=("docs/debugging.txt")
