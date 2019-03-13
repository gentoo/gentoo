# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NWCLARK
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="PerlIO layer to gzip/gunzip"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
