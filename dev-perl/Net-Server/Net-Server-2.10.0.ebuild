# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RHANDOM
DIST_VERSION=2.010
inherit perl-module

DESCRIPTION="Extensible, general Perl server engine"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="ipv6"

RDEPEND="
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-Time-HiRes
	dev-perl/IO-Multiplex
	ipv6? ( dev-perl/IO-Socket-INET6 )
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

# Parallel testing causes tests to randomly fail
DIST_TEST="do"
