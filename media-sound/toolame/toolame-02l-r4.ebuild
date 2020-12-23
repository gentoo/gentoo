# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="tooLAME - an optimized mpeg 1/2 layer 2 audio encoder"
HOMEPAGE="http://www.planckenergy.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-uint.patch
	"${FILESDIR}"/${P}-uint32_t.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	append-lfs-flags
	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc -r README HISTORY FUTURE html/. text/.
}
