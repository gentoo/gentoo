# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ngircd/ngircd-20.3.ebuild,v 1.4 2015/02/22 09:16:18 mgorny Exp $

EAPI="5"

inherit autotools-utils eutils user

DESCRIPTION="A IRC server written from scratch"
HOMEPAGE="http://ngircd.barton.de/"
SRC_URI="ftp://ngircd.barton.de/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86 ~x64-macos"
IUSE="debug gnutls ident ipv6 pam ssl tcpd zlib"

RDEPEND="
	ident? ( net-libs/libident )
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl )
	)
	pam? ( virtual/pam )
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
		$(use_enable ipv6)
		$(use_with zlib)
		$(use_with tcpd tcp-wrappers)
		$(use_with ident)
		$(use_with pam)
		$(use_enable debug)
		$(use_enable debug sniffer)
	)

	if use ssl; then
		myeconfargs+=(
			$(use_with !gnutls openssl)
			$(use_with gnutls)
		)
	else
		myeconfargs+=(
			--without-gnutls
			--without-ssl
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
