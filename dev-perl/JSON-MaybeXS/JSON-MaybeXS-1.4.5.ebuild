# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.004005
inherit perl-module

DESCRIPTION="Use Cpanel::JSON::XS with a fallback to JSON::XS and JSON::PP"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+xs"

# needs Scalar-Util
RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-JSON-PP-2.273.0
	virtual/perl-Scalar-List-Utils
	xs? (
		|| (
			>=dev-perl/Cpanel-JSON-XS-2.331.0
			>=dev-perl/JSON-XS-3.0.0
		)
	)
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Needs-0.2.6
	)
"
