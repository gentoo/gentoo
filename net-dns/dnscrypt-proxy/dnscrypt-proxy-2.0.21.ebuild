# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/jedisct1/${PN}"

inherit fcaps golang-build systemd user

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://${EGO_PN}.git"
else
	SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="A flexible DNS proxy, with support for encrypted DNS protocols"
HOMEPAGE="https://github.com/jedisct1/dnscrypt-proxy"

LICENSE="ISC"
SLOT="0"
IUSE="pie"

DEPEND=">=dev-lang/go-1.12"

FILECAPS=( cap_net_bind_service+ep usr/bin/dnscrypt-proxy )
PATCHES=( "${FILESDIR}"/config-full-paths-r10.patch )

pkg_setup() {
	enewgroup dnscrypt-proxy
	enewuser dnscrypt-proxy -1 -1 /var/empty dnscrypt-proxy
}

src_prepare() {
	default
	# Create directory structure suitable for building
	mkdir -p "src/${EGO_PN%/*}" || die
	# fixes $GOPATH/go.mod exists but should not
	rm go.mod || die
	mv "${PN}" "src/${EGO_PN}" || die
	mv "vendor" "src/" || die
}

src_configure() {
	EGO_BUILD_FLAGS="-buildmode=$(usex pie pie default)"
}

src_install() {
	dobin dnscrypt-proxy

	insinto /etc/dnscrypt-proxy
	newins "src/${EGO_PN}"/example-dnscrypt-proxy.toml dnscrypt-proxy.toml
	doins "src/${EGO_PN}"/example-{blacklist.txt,whitelist.txt}
	doins "src/${EGO_PN}"/example-{cloaking-rules.txt,forwarding-rules.txt}

	insinto /usr/share/dnscrypt-proxy
	doins -r "utils/generate-domains-blacklists/."

	newinitd "${FILESDIR}"/dnscrypt-proxy.initd dnscrypt-proxy
	newconfd "${FILESDIR}"/dnscrypt-proxy.confd dnscrypt-proxy
	systemd_newunit "${FILESDIR}"/dnscrypt-proxy.service dnscrypt-proxy.service
	systemd_newunit "${FILESDIR}"/dnscrypt-proxy.socket dnscrypt-proxy.socket

	einstalldocs
}

pkg_postinst() {
	fcaps_pkg_postinst

	if ! use filecaps; then
		ewarn "'filecaps' USE flag is disabled"
		ewarn "${PN} will fail to listen on port 53"
		ewarn "please do one the following:"
		ewarn "1) re-enable 'filecaps'"
		ewarn "2) change port to > 1024"
		ewarn "3) configure to run ${PN} as root (not recommended)"
		ewarn
	fi

	if systemd_is_booted || has_version sys-apps/systemd; then
		elog "Using systemd socket activation may cause issues with speed"
		elog "latency and reliability of ${PN} and is discouraged by upstream"
		elog "Existing installations advised to disable 'dnscrypt-proxy.socket'"
		elog "It is disabled by default for new installations"
		elog "check "$(systemd_get_systemunitdir)/${PN}.service" for details"
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
