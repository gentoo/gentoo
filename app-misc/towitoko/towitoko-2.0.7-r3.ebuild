# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Driver for Towitoko smartcard readers"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
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
		elog "https://www.matrica.de"
		elog "then please re-emerge this package with 'moneyplex' in USE"
	fi
}
