# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/softgun/softgun-0.11.ebuild,v 1.2 2007/01/25 22:53:19 genone Exp $

inherit toolchain-funcs

DESCRIPTION="ARM software emulator"
HOMEPAGE="http://softgun.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/^CFLAGS/s:-O9.*-fomit-frame-pointer:${CFLAGS}:" \
		config.mk || die "sed config.mk failed"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "Make feiled"
}

src_install() {
	dodir /usr/bin
	make install prefix="${D}/usr" || die "Install failed"
	dodoc README configs/defaultconfig
}

pkg_postinst() {
	elog "To create a configuration file, run as user:"
	elog "   gzcat /usr/share/doc/${PF}/defaultconfig.gz > ~/.emuconfig"
}
