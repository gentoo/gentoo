# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RHANDOM
DIST_VERSION=2.009
inherit perl-module eutils

DESCRIPTION="Extensible, general Perl server engine"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="ipv6"

RDEPEND="
	dev-perl/IO-Multiplex
	ipv6? ( dev-perl/IO-Socket-INET6 )
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"
# Parallel testing causes tests to randomly fail
DIST_TEST="do"
