# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JMASLAK
DIST_VERSION=2.0001
inherit perl-module

DESCRIPTION="Parse, manipulate and lookup IP network blocks"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
