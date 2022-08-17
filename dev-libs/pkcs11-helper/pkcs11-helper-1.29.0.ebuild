# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PKCS#11 helper library"
HOMEPAGE="https://github.com/OpenSC/pkcs11-helper"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc gnutls nss"

RDEPEND=">=dev-libs/openssl-0.9.7:=
	gnutls? ( >=net-libs/gnutls-1.4.4:= )
	nss? ( dev-libs/nss )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.4.7 )"

src_configure() {
	econf \
		--disable-crypto-engine-polarssl \
		--disable-crypto-engine-mbedtls \
		$(use_enable doc) \
		$(use_enable gnutls crypto-engine-gnutls) \
		$(use_enable nss crypto-engine-nss)
}

src_install() {
	default

	# bug #555262
	rm "${ED}"/usr/share/doc/${PF}/COPYING.{BSD,GPL} || die

	find "${ED}" -name '*.la' -delete || die
}
