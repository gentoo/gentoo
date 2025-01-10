# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd tmpfiles

DESCRIPTION="Dynamic DNS client with multiple SSL/TLS library support"
HOMEPAGE="https://github.com/troglobit/inadyn"
SRC_URI="https://github.com/troglobit/inadyn/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gnutls mbedtls openssl"
REQUIRED_USE="?? ( gnutls mbedtls openssl )"

DEPEND="
	acct-group/inadyn
	acct-user/inadyn
	dev-libs/confuse:=
	gnutls? (
		dev-libs/nettle:=
		net-libs/gnutls:=
	)
	mbedtls? ( net-libs/mbedtls:3= )
	openssl? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-2.12.0-musl.patch" )

src_prepare() {
	default
	# Adjust mbedtls pkg-config module
	sed -i \
		-e "s:\[mbedtls\]:\[mbedtls3\]:g" \
		-e "s:\[mbedcrypto\]:\[mbedcrypto3\]:g" \
		-e "s:\[mbedx509\]:\[mbedx5093\]:g" \
		configure.ac || die
	eautoreconf
}

src_configure() {
	# Tests would need a custom config file in homedir per configure help?
	local myeconfargs=(
		--with-systemd="$(systemd_get_systemunitdir)"
		$(use_enable mbedtls)
		$(use_enable openssl)
	)
	if use gnutls || use mbedtls || use openssl; then
		myeconfargs+=( --enable-ssl )
	else
		myeconfargs+=( --disable-ssl )
	fi

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
