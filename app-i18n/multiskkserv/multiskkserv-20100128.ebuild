# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="SKK server that handles multiple dictionaries"
HOMEPAGE="http://www3.big.or.jp/~sian/linux/products/"
SRC_URI="http://www3.big.or.jp/~sian/linux/products/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="|| (
		dev-db/tinycdb
		dev-db/cdb
	)
	test? ( app-i18n/nkf )"
RDEPEND="app-i18n/skk-jisyo[cdb]"

PATCHES=( "${FILESDIR}"/${PN}-cdb.patch )

src_prepare() {
	default
	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	econf --with-cdb="${EPREFIX}"/usr
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
