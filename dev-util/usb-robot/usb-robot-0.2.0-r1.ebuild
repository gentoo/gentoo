# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="USB Reverse engineering tools"
HOMEPAGE="https://usb-robot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="virtual/libusb:0
	sys-libs/readline:="
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)"
}
