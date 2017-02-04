# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"

KEYWORDS="~amd64 ~hppa ~x86"
IUSE="bindist libressl +migration-tool test"
SLOT="2"
LICENSE="BSD"

RDEPEND="
	sys-devel/gcc:=[cxx]
	dev-db/sqlite:3
	!libressl? ( dev-libs/openssl:=[bindist=] )
	libressl? ( dev-libs/libressl )
	!=dev-libs/softhsm-2.0.0:0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-libressl.patch"
)
DOCS=( NEWS README.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-crypto-backend=openssl \
		--disable-p11-kit \
		$(use_enable !bindist ecc) \
		$(use_enable !libressl ghost) \
		$(use_with migration-tool migrate)
}

src_install() {
	default
	prune_libtool_files --modules
}
