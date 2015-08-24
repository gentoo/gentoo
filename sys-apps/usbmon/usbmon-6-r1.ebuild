# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Userland for USB monitoring framework"
HOMEPAGE="https://people.redhat.com/zaitcev/linux/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="!=sys-apps/usbutils-0.72-r2"

src_prepare() {
	sed \
		-e '/CFLAGS =/s, = , \+= ,g' \
		-e 's:-O2::g' \
		-i "${S}"/Makefile || die
	tc-export CC
}

src_install() {
	dosbin ${PN}
	doman ${PN}.8
	dodoc README
}
