# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DDICK
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Replaces actual time with simulated time"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	virtual/perl-Time-Piece
	virtual/perl-Time-Local
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=( "t/pod.t" )
