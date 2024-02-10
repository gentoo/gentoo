# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DDICK
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Replaces actual time with simulated time"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	virtual/perl-Time-Piece
	virtual/perl-Time-Local
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=( "t/pod.t" )
