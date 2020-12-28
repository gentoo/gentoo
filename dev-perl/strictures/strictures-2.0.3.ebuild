# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=2.000003
inherit perl-module

DESCRIPTION="Turn on strict and make most warnings fatal"

SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		dev-perl/bareword-filehandles
		dev-perl/indirect
		dev-perl/multidimensional
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
