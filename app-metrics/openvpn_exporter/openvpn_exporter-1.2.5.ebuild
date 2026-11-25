# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

COMMIT=beb588256c024c7faea767b59964c41bf043e761

DESCRIPTION="Prometheus Exporter for OpenVPN"
HOMEPAGE="https://github.com/natrontech/openvpn_exporter"
SRC_URI="https://github.com/natrontech/${PN/_/-}/archive/v${PV}.tar.gz -> ${P/_/-}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN/_/-}/releases/download/v${PV}/${P/_/-}-vendor.tar.xz"
S=${WORKDIR}/${P/_/-}

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-user/openvpn_exporter
	acct-group/openvpn_exporter
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.27.1"

src_compile() {
	local go_ldflags=(
		-w
		-X main.Version=${PV}
		-X main.Commit=${COMMIT}
		-X main.BuildTime="$(date +%Y%m%d-%T)"
	)
	ego build -ldflags "${go_ldflags[*]}" -trimpath -tags="netgo" -o ${PN}
}

src_install() {
	dobin ${PN}
	dodoc {CHANGELOG,README}.md

	keepdir "/var/log/${PN}"
	fowners ${PN}:${PN} "/var/log/${PN}"

	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-1.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt 1; then
			ewarn "${PN} switched to the maintained natrontech fork, which renamed"
			ewarn "the -openvpn.status_paths flag to -openvpn.status-files."
			ewarn "Configuration is now done via OPENVPN_* variables, see"
			ewarn "/etc/conf.d/${PN}. Make sure to update it, otherwise the"
			ewarn "service will fail to start."
			break
		fi
	done
}
