# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=VINSWORLD
DIST_VERSION=1.12
DIST_WIKI="tests"
inherit perl-module

DESCRIPTION="Automate telnet sessions w/ routers&switches"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-perl/Net-Telnet-3.20.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/TermReadKey )
"

PATCHES=( "${FILESDIR}/${PN}-1.11-no-interactive-test.patch" )

PERL_RM_FILES=( "t/02-pod-coverage.t" )
