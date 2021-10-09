# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RURBAN
DIST_VERSION=1.26
inherit perl-module

DESCRIPTION="Walk Perl syntax tree, printing debug info about ops"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		>=dev-perl/B-Flags-0.40.0
	)
	>=dev-lang/perl-5.19.2
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( "t/pod.t" )
