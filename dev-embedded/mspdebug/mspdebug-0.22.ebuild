# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/mspdebug/mspdebug-0.22.ebuild,v 1.2 2013/09/08 19:41:54 xmw Exp $

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="A free debugger for use with MSP430 MCUs"
HOMEPAGE="http://mspdebug.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline )
	virtual/libusb:0"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s:-O1 \(.*\) -ggdb:\1:" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR=/usr/lib $(usex readline "" "WITHOUT_READLINE=1")
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR=/usr/lib PREFIX=/usr install
	dodoc AUTHORS ChangeLog README
}
