# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Driver for Towitoko smartcard readers"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="https://www.gentoo.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

IUSE="moneyplex"

src_configure() {
	local myconf
	use moneyplex && myconf="--disable-atr-check"
	econf \
		$(use_enable moneyplex win32-com) \
		"${myconf}"
}

pkg_postinst() {
	if ! use moneyplex; then
		elog "If you want to use the moneyplex home banking software from"
		elog "http://www.matrica.de"
		elog "then please re-emerge this package with 'moneyplex' in USE"
	fi
}
