# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/jedisct1/${PN}"

inherit fcaps golang-build systemd user

DESCRIPTION="A flexible DNS proxy, with support for encrypted DNS protocols"
HOMEPAGE="https://github.com/jedisct1/dnscrypt-proxy"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

FILECAPS=( cap_net_bind_service+ep usr/bin/dnscrypt-proxy )
PATCHES=( "${FILESDIR}"/config-full-paths-r2.patch )

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_compile() {
	# Create directory structure suitable for building
	mkdir -p "src/${EGO_PN%/*}" || die
	mv "${PN}" "src/${EGO_PN}" || die
	mv "vendor" "src/" || die
	golang-build_src_compile
}

src_install() {
	dobin dnscrypt-proxy

	insinto /etc/dnscrypt-proxy
	newins "src/${EGO_PN}"/example-dnscrypt-proxy.toml dnscrypt-proxy.toml
	doins "src/${EGO_PN}"/example-{blacklist.txt,cloaking-rules.txt,forwarding-rules.txt}

	insinto "/usr/share/dnscrypt-proxy"
	doins -r "utils/generate-domains-blacklists/."

	newinitd "${FILESDIR}"/dnscrypt-proxy.initd-r2 dnscrypt-proxy
	newconfd "${FILESDIR}"/dnscrypt-proxy.confd-r2 dnscrypt-proxy
	systemd_newunit "${FILESDIR}"/${PN}.service-r2 dnscrypt-proxy.service
	systemd_dounit systemd/dnscrypt-proxy.socket

	keepdir /var/log/dnscrypt-proxy

	einstalldocs
}

pkg_postinst() {
	fcaps_pkg_postinst

	if ! use filecaps; then
		ewarn "'filecaps' USE flag is disabled"
		ewarn "${PN} will fail to listen on port 53 if started via OpenRC"
		ewarn "please either change port to > 1024, configure to run ${PN} as root"
		ewarn "or re-enable 'filecaps'"
		ewarn
	fi

	local v
	for v in ${REPLACING_VERSIONS}; do
		if [[ ${v} == 1.* ]] ; then
			elog "Version 2.x.x is a complete rewrite of ${PN}"
			elog "please clean up old config/log files"
			elog
		fi
	done

	if systemd_is_booted || has_version sys-apps/systemd; then
		elog "To use systemd socket activation with ${PN} you must"
		elog "set listen_addresses setting to \"[]\" in the config file"
		elog "Edit ${PN}.socket if you need to change port and address"
		elog
	fi

	elog "After starting the service you will need to update your"
	elog "/etc/resolv.conf and replace your current set of resolvers"
	elog "with:"
	elog
	elog "nameserver 127.0.0.1"
	elog
	elog "Also see https://github.com/jedisct1/${PN}/wiki"
}
