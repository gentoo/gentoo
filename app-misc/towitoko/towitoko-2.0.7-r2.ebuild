# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

IUSE="moneyplex"

DESCRIPTION="This library provides a driver for using Towitoko smartcard readers under UNIX environment"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="https://www.gentoo.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"

src_compile() {
	local myconf

	myconf=""
	use moneyplex && myconf="${myconf} --disable-atr-check"

	econf \
		$(use_enable moneyplex win32-com) \
		${myconf} || die "econf failed"
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	if ! use moneyplex
	then
		elog "If you want to use the moneyplex home banking software from"
		elog "http://www.matrica.de"
		elog "then please re-emerge this package with 'moneyplex' in USE"
	fi
}
