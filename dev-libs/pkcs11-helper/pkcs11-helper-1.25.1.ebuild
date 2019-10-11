# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="PKCS#11 helper library"
HOMEPAGE="https://github.com/OpenSC/pkcs11-helper"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE="bindist doc gnutls libressl nss static-libs"

RDEPEND="
	!libressl? ( >=dev-libs/openssl-0.9.7:0=[bindist=] )
	libressl? ( dev-libs/libressl )
	gnutls? ( >=net-libs/gnutls-1.4.4 )
	nss? ( dev-libs/nss )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.4.7 )"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

src_configure() {
	econf \
		--disable-crypto-engine-polarssl \
		--disable-crypto-engine-mbedtls \
		$(use_enable doc) \
		$(use_enable gnutls crypto-engine-gnutls) \
		$(use_enable nss crypto-engine-nss) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
