# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=2.000006
inherit perl-module

DESCRIPTION="Turn on strict and make most warnings fatal"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/bareword-filehandles
		dev-perl/indirect
		dev-perl/multidimensional
	)
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
