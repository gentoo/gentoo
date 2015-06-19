# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnscrypt-proxy/dnscrypt-proxy-1.4.3.ebuild,v 1.1 2015/01/20 07:40:55 dlan Exp $

EAPI=5

inherit eutils systemd user

DESCRIPTION="A tool for securing communications between a client and a DNS resolver"
HOMEPAGE="http://dnscrypt.org/"
SRC_URI="http://download.dnscrypt.org/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plugins ldns systemd"

DEPEND="dev-libs/libsodium
	ldns? ( net-libs/ldns )"
RDEPEND="${DEPEND}
	systemd? ( sys-apps/systemd )"

DOCS=( AUTHORS ChangeLog COPYING NEWS README.markdown README-PLUGINS.markdown
	TECHNOTES THANKS )

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_configure() {
	econf \
		$(use_enable plugins) \
		$(use_with systemd )
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}
