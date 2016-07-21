# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="SKK server that handles multiple dictionaries"
HOMEPAGE="http://www3.big.or.jp/~sian/linux/products/"
SRC_URI="http://www3.big.or.jp/~sian/linux/products/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

DEPEND="app-arch/xz-utils
	dev-db/cdb
	test? ( app-i18n/nkf )"
RDEPEND="|| (
		>=app-i18n/skk-jisyo-200705[cdb]
		app-i18n/skk-jisyo-cdb
	)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cdb.patch
	eautoreconf
}

src_configure() {
	econf --with-cdb=yes
}

src_install() {
	default

	newconfd "${FILESDIR}"/multiskkserv.conf multiskkserv
	newinitd "${FILESDIR}"/multiskkserv.initd multiskkserv
}

pkg_postinst() {
	elog "By default, multiskkserv will look up only SKK-JISYO.L.cdb."
	elog "If you want to use more dictionaries,"
	elog "edit /etc/conf.d/multiskkserv manually."
}
