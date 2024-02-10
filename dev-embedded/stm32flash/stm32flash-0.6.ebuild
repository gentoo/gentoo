# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Open source flash program for STM32 using the ST serial bootloader"
HOMEPAGE="https://sourceforge.net/projects/stm32flash/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/stm32flash-0.6-fix-i2c-erase-b079cd0.patch"
	"${FILESDIR}/stm32flash-0.6-fix-i2c-erase-17a24f8.patch"
	"${FILESDIR}/stm32flash-0.6-fix-i2c-erase-01fbb65.patch"
)

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
