# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEZUMI
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="An eucJP-open mapping"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

PERL_RM_FILES=( "t/pod.t" )
RDEPEND=">=virtual/perl-Encode-1.140.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
