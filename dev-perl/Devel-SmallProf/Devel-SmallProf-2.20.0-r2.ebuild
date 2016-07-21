# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SALVA
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="Per-line Perl profiler"

SLOT="0"
KEYWORDS="amd64 sparc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-defined.patch"
)

SRC_TEST="do"
# note: dont use parallel here
