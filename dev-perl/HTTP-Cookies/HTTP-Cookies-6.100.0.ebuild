# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OALDERS
DIST_VERSION=6.10
inherit perl-module

DESCRIPTION="Storage of cookies"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Carp
	>=dev-perl/HTTP-Date-6.0.0
	>=dev-perl/HTTP-Message-6.0.0
	virtual/perl-Time-Local
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
		virtual/perl-Test-Simple
		dev-perl/URI
	)
"
