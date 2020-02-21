# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=CHOCOLATE
DIST_VERSION=2.86
inherit perl-module

DESCRIPTION="Call methods on native types"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Scope-Guard-0.210.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/IPC-System-Simple-1.250.0
	)
"
PERL_RM_FILES=( "t/pod.t" )
