# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SULLR
DIST_VERSION=2.045
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Nearly transparent SSL encapsulation for IO::Socket::INET"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="idn"

RDEPEND="
	>=dev-perl/Net-SSLeay-1.460.0
	virtual/perl-Scalar-List-Utils
	idn? (
		|| (
			>=dev-perl/URI-1.50
			dev-perl/Net-LibIDN
			dev-perl/Net-IDN-Encode
		)
	)"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
mydoc=("docs/debugging.txt")
