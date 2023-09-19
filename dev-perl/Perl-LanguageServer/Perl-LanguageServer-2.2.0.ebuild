# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GRICHTER
inherit perl-module

DESCRIPTION="Language Server and Debug Protocol Adapter for Perl"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/AnyEvent-AIO
	dev-perl/Class-Refresh
	>=dev-perl/Compiler-Lexer-0.230.0
	dev-perl/Coro
	dev-perl/Data-Dump
	dev-perl/IO-AIO
	dev-perl/JSON
	dev-perl/Moose
	dev-perl/PadWalker
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
