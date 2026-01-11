# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="LSI MegaRAID control utility"
HOMEPAGE="https://github.com/namiltd/megactl/"
SRC_URI="https://github.com/namiltd/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scsi +sas"

PATCHES=( "${FILESDIR}"/${P}-gcc-fixes.patch
	"${FILESDIR}"/${P}-tracefix.patch )

src_compile() {
	use x86 && MY_MAKEOPTS="ARCH=-m32"
	use amd64 && MY_MAKEOPTS="ARCH=-m64"
	emake -C . CC=$(tc-getCC) ${MY_MAKEOPTS}
}

src_install() {
	if use scsi; then
		dosbin megactl megarpt
	fi
	if use sas; then
		dosbin megasasctl megasasrpt
	fi
	dodoc ./README
}
