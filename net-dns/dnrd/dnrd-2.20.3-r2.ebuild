# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools user

DESCRIPTION="A caching DNS proxy server"
HOMEPAGE="http://dnrd.sourceforge.net/"
SRC_URI="mirror://sourceforge/dnrd/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=( "${FILESDIR}"/${P}-docdir.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	keepdir /etc/dnrd
	doinitd "${FILESDIR}"/dnrd
	newconfd "${FILESDIR}"/dnrd.conf dnrd
}

pkg_postinst() {
	enewgroup dnrd
	enewuser dnrd -1 -1 /dev/null dnrd
}
