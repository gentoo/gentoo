# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="tools for generating YAFFS images"
HOMEPAGE="https://code.google.com/p/yaffs2utils/"
SRC_URI="https://yaffs2utils.googlecode.com/files/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

S=${WORKDIR}/${PV}

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-build.patch
	eapply "${FILESDIR}"/${P}-unyaffs2-pointer.patch
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin unspare2 mkyaffs2 unyaffs2
	dodoc CHANGES README
}
