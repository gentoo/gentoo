# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHANSEN
DIST_VERSION=0.6
inherit perl-module

DESCRIPTION="Simple Passwd authentication"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-perl/Authen-Simple-0.300.0
	virtual/perl-IO
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"

PERL_RM_FILES=( "t/02pod.t" "t/03podcoverage.t" )
