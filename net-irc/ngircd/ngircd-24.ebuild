# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit user

DESCRIPTION="An IRC server written from scratch"
HOMEPAGE="https://ngircd.barton.de/"
SRC_URI="https://arthur.barton.de/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"
IUSE="debug gnutls iconv ident ipv6 libressl pam ssl tcpd test zlib"

RDEPEND="
	iconv? ( virtual/libiconv )
	ident? ( net-libs/libident )
	pam? ( virtual/pam )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)
	tcpd? ( sys-apps/tcp-wrappers )
	zlib? ( sys-libs/zlib )
"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	test? (
		dev-tcltk/expect
		net-misc/netkit-telnetd
	)
"

# Testsuite fails server-login-test
RESTRICT="test"

src_prepare() {
	default

	if ! use prefix; then
		sed -i \
			-e "s:;ServerUID = 65534:ServerUID = ngircd:" \
			-e "s:;ServerGID = 65534:ServerGID = nogroup:" \
			doc/sample-ngircd.conf.tmpl || die
	fi
}

src_configure() {
	local myconf=(
		--sysconfdir="${EPREFIX}"/etc/"${PN}"
		$(use_enable debug sniffer)
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_with iconv)
		$(use_with ident)
		$(use_with pam)
		$(use_with tcpd tcp-wrappers)
		$(use_with zlib)
	)

	if use ssl; then
		myconf+=(
			$(use_with !gnutls openssl)
			$(use_with gnutls)
		)
	else
		myconf+=(
			--without-gnutls
			--without-openssl
		)
	fi

	econf "${myconf[@]}"
}

src_install() {
	default
	newinitd "${FILESDIR}"/ngircd.init-r1.d ngircd
}

pkg_postinst() {
	if ! use prefix; then
		enewuser ngircd
		chown ngircd "${EROOT%/}"/etc/ngircd/ngircd.conf || die
	fi
}
