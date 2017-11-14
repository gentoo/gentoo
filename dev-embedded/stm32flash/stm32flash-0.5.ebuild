# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Open source flash program for STM32 using the ST serial bootloader"
HOMEPAGE="https://sourceforge.net/projects/stm32flash/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
