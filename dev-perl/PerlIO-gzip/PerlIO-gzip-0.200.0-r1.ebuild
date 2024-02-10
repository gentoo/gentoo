# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NWCLARK
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="PerlIO layer to gzip/gunzip"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
"
BDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
