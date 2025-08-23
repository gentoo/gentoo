# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="tooLAME - an optimized mpeg 1/2 layer 2 audio encoder"
HOMEPAGE="http://www.planckenergy.com"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"

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
