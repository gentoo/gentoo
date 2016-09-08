# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_PN="af_alg"

inherit autotools eutils libtool linux-info versionator

DESCRIPTION="af_alg is an openssl crypto engine kernel interface thing"
HOMEPAGE="https://github.com/sarnold/af_alg"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="libressl"

DEPEND="virtual/linux-sources
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
RDEPEND=""

RESTRICT="test"

S=${WORKDIR}/${MY_PN}-${PV}

CONFIG_CHECK="~CRYPTO_USER_API"
WARNING_CRYPTO_USER_API="You need to enable CONFIG_CRYPTO_USER_API in order to use this package."

src_prepare() {
	sed -i -e "s|ssl/engines|engines|" "${S}"/configure.ac
	eautoreconf
}

src_configure() {
	econf --with-pic
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README.rst

	prune_libtool_files --modules
}
