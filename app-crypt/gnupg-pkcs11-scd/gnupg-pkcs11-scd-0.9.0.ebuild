# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit user

DESCRIPTION="PKCS#11 support for GnuPG"
HOMEPAGE="http://gnupg-pkcs11.sourceforge.net"
SRC_URI="https://github.com/alonbl/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl proxy"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/libassuan:=
	>=dev-libs/libgcrypt-1.2.2:=
	>=dev-libs/libgpg-error-1.3:=
	>=dev-libs/pkcs11-helper-1.02:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use proxy; then
		enewgroup gnupg-pkcs11
		enewgroup gnupg-pkcs11-scd-proxy
		enewuser gnupg-pkcs11-scd-proxy -1 -1 / gnupg-pkcs11-scd-proxy,gnupg-pkcs11
	fi
}

src_configure() {
	econf \
		$(use_enable proxy) \
		--with-proxy-socket=/run/gnupg-pkcs11-scd-proxy/cmd
}

src_install() {
	default
	if use proxy; then
		newinitd "${FILESDIR}/gnupg-pkcs11-scd-proxy.initd" gnupg-pkcs11-scd-proxy
		newconfd "${FILESDIR}/gnupg-pkcs11-scd-proxy.confd" gnupg-pkcs11-scd-proxy
	fi
}
