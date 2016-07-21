# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils toolchain-funcs

MY_PV="v${PV}"
SRC_URI="https://github.com/linux-sunxi/sunxi-tools/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Tools for Allwinner A10 devices."
HOMEPAGE="http://linux-sunxi.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

DEPEND="virtual/libusb"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -std=c99 -D_POSIX_C_SOURCE=200112L -Iinclude/" all misc
}

src_install() {
	dobin bin2fex fex2bin phoenix_info
	newbin sunxi-bootinfo bootinfo
	newbin sunxi-fel fel
	newbin sunxi-fexc fexc
	newbin sunxi-nand-part nand-part
	newbin sunxi-pio pio
}
