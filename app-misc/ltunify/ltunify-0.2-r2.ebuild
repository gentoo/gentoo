# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Tool for working with Logitech Unifying receivers and devices"
HOMEPAGE="https://lekensteyn.nl/logitech-unifying.html https://git.lekensteyn.nl/ltunify/"
SRC_URI="https://git.lekensteyn.nl/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i '/^override CFLAGS/d' Makefile || die
	tc-export CC
}

src_compile() {
	emake ${PN}
}

src_install() {
	dobin ${PN}
	dodoc NEWS README.txt udev/42-logitech-unify-permissions.rules
}
