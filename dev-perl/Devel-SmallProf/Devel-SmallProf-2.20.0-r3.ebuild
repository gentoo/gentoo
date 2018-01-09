# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SALVA
DIST_VERSION=2.02
inherit perl-module

DESCRIPTION="Per-line Perl profiler"

SLOT="0"
KEYWORDS="amd64 sparc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-defined.patch"
	"${FILESDIR}/${P}-perl526.patch"
)
# note: dont use parallel here
# tests need each others exit state
DIST_TEST="do"
