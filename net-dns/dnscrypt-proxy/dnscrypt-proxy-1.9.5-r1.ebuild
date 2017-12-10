# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

DESCRIPTION="A tool for securing communications between a client and a DNS resolver"
HOMEPAGE="https://dnscrypt.org"
SRC_URI="https://download.dnscrypt.org/${PN}/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="hardened libressl +plugins ssl systemd"

RDEPEND="
	dev-libs/libsodium
	net-libs/ldns
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_configure() {
	econf \
		$(use_enable hardened pie) \
		$(use_enable plugins) \
		$(use_enable ssl openssl) \
		$(use_with systemd)
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README* THANKS *txt )

	default

	exeinto /usr/share/dnscrypt-proxy
	doexe ${S}/contrib/dnscrypt-update-resolvers.sh
	doexe ${S}/contrib/generate-domains-blacklist.py
	doexe ${S}/contrib/resolvers-check.sh

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	systemd_newunit "${FILESDIR}"/${PN}.socket-r1 ${PN}.socket
	systemd_newunit "${FILESDIR}"/dnscrypt-update-resolvers.timer dnscrypt-update-resolvers.timer
	systemd_newunit "${FILESDIR}"/dnscrypt-update-resolvers.service dnscrypt-update-resolvers.service
	insinto /etc
	doins "${FILESDIR}"/${PN}.conf /etc
}

pkg_preinst() {
	# ship working default configuration for systemd users
	if use systemd; then
		sed -i 's/Daemonize yes/Daemonize no/g' "${D}"/etc/${PN}.conf
	fi
}

pkg_postinst() {
	elog "After starting the service you will need to update your"
	elog "/etc/resolv.conf and replace your current set of resolvers"
	elog "with:"
	elog
	elog "nameserver 127.0.0.1"
	elog
	use systemd && elog "with systemd dnscrypt-proxy ignores LocalAddress setting in the config file"
	use systemd && elog "edit dnscrypt-proxy.socket if you need to change the defaults"
	elog
	elog "Also see https://github.com/jedisct1/dnscrypt-proxy#usage."
}
