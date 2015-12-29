# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools-utils eutils user

DESCRIPTION="An IRC server written from scratch"
HOMEPAGE="http://ngircd.barton.de/"
SRC_URI="http://ngircd.barton.de/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="debug gnutls iconv ident ipv6 libressl pam ssl tcpd zlib"

RDEPEND="
	iconv? ( virtual/libiconv )
	ident? ( net-libs/libident )
	pam? ( virtual/pam )
	ssl? (
		!gnutls? (
			!libressl? ( dev-libs/openssl:0 )
		)
		gnutls? ( net-libs/gnutls )
		libressl? ( dev-libs/libressl )
	)
	tcpd? ( sys-apps/tcp-wrappers )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
"

RESTRICT="test"

src_configure() {
	if ! use prefix; then
		sed -i \
			-e "s:;ServerUID = 65534:ServerUID = ngircd:" \
			-e "s:;ServerGID = 65534:ServerGID = nogroup:" \
			doc/sample-ngircd.conf.tmpl || die
	fi

	local myeconfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--sysconfdir="${EPREFIX}"/etc/ngircd
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
		myeconfargs+=(
			$(use_with !gnutls openssl)
			$(use_with gnutls)
		)
	else
		myeconfargs+=(
			--without-gnutls
			--without-openssl
		)
	fi

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	newinitd "${FILESDIR}"/ngircd.init.d ngircd
}

pkg_postinst() {
	if ! use prefix; then
		enewuser ngircd
		chown ngircd "${ROOT}"/etc/ngircd/ngircd.conf
	fi
}
