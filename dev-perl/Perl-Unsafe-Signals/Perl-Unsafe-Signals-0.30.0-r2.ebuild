# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RGARCIA
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Allow unsafe handling of signals in selected blocks"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=( "t/pod.t" )
