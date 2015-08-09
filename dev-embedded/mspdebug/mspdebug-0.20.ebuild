# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A free debugger for use with MSP430 MCUs"
HOMEPAGE="http://mspdebug.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline )
	virtual/libusb:0"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:-O1 \(.*\) -ggdb:\1:" Makefile
}

src_compile() {
	local myflags
	! use readline && myflags="WITHOUT_READLINE=1"

	emake CC="$(tc-getCC)" ${myflags}
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr install
	dodoc AUTHORS ChangeLog README
}
