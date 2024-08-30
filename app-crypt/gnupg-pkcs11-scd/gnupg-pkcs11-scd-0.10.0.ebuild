# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PKCS#11 support for GnuPG"
HOMEPAGE="https://sourceforge.net/projects/gnupg-pkcs11/"
SRC_URI="https://github.com/alonbl/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="proxy"

DEPEND="
	dev-libs/openssl:=
	<dev-libs/libassuan-3:=
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error:=
	dev-libs/pkcs11-helper:="
RDEPEND="
	${DEPEND}
	proxy? (
		acct-group/gnupg-pkcs11
		acct-group/gnupg-pkcs11-scd-proxy
		acct-user/gnupg-pkcs11-scd-proxy
	)"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_enable proxy)
		--with-proxy-socket=/run/gnupg-pkcs11-scd-proxy/cmd
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use proxy; then
		newinitd "${FILESDIR}"/gnupg-pkcs11-scd-proxy.initd gnupg-pkcs11-scd-proxy
		newconfd "${FILESDIR}"/gnupg-pkcs11-scd-proxy.confd gnupg-pkcs11-scd-proxy
	fi
}
