# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KASEI
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="MySQL-specific functions for Time::Piece"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"

RDEPEND="
	>=virtual/perl-Time-Piece-1.15
"
BDEPEND="${RDEPEND}
"
