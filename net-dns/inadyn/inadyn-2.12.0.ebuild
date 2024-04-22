# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd tmpfiles

DESCRIPTION="Dynamic DNS client with multiple SSL/TLS library support"
HOMEPAGE="https://github.com/troglobit/inadyn"
SRC_URI="https://github.com/troglobit/inadyn/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gnutls mbedtls openssl"
REQUIRED_USE="?? ( gnutls mbedtls openssl )"

DEPEND="
	acct-group/inadyn
	acct-user/inadyn
	dev-libs/confuse:=
	gnutls? (
		dev-libs/nettle:=
		net-libs/gnutls:0=
	)
	mbedtls? ( net-libs/mbedtls:0= )
	openssl? ( dev-libs/openssl:0= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=( "--disable-ssl" )
	if use gnutls || use mbedtls || use openssl; then
		local myeconfargs=( "--enable-ssl" )
	fi

	if use mbedtls; then
		myeconfargs+=( "--enable-mbedtls" )

		# MbedTLS has no support for pkg-config
		myeconfargs+=( MbedTLS_CFLAGS="-I/usr/include/mbedtls" )
		myeconfargs+=( MbedTLS_LIBS="-lmbedtls" )
	fi
	use openssl && myeconfargs+=( "--enable-openssl" )

	myeconfargs+=( --with-systemd="$(systemd_get_systemunitdir)" )

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto	/etc
	insopts -m 0600 -o inadyn -g inadyn
	doins examples/inadyn.conf

	newinitd "${FILESDIR}"/inadyn.initd inadyn
	newconfd "${FILESDIR}"/inadyn.confd inadyn

	newtmpfiles "${FILESDIR}"/inadyn.tmpfilesd inadyn.conf
}

pkg_postinst() {
	tmpfiles_process inadyn.conf
}
