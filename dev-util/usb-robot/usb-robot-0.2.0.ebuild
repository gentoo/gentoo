# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/usb-robot/usb-robot-0.2.0.ebuild,v 1.12 2009/08/01 01:24:23 vostorga Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="USB Reverse engineering tools"
HOMEPAGE="http://usb-robot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="virtual/libusb:0
	sys-libs/readline"
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install () {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS NEWS README ChangeLog
}
