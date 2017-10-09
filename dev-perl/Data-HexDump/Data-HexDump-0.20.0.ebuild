# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=FTASSIN
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="A Simple Hexadecial Dumper"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-hexdump-pl.patch"
	"${FILESDIR}/${P}-lib-pm.patch"
	"${FILESDIR}/${P}-signed-c.patch"
)
