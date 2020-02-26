# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit libtool eutils

MY_PV=${PV/_rc/.rc}
MY_PV=${MY_PV/_a/.a}
MY_P=${P/_rc/.rc}
MY_P=${MY_P/_a/.a}

DESCRIPTION="389 adminutil"
HOMEPAGE="http://port389.org/"
SRC_URI="http://port389.org/sources/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

COMMON_DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	>=dev-libs/svrcore-4.0.3
	>=dev-libs/cyrus-sasl-2.1.19
	>=dev-libs/icu-3.4:=
	net-nds/openldap"
DEPEND="virtual/pkgconfig ${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf $(use_enable debug) \
		--with-fhs \
		--with-openldap \
		--disable-rpath \
		--disable-tests
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README  NEWS
}
