# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="MQTT broker library with cluster support that implements MQTT V5.0 and V3.1.1"
HOMEPAGE="https://github.com/DrmagicE/gmqtt"
SRC_URI="https://github.com/DrmagicE/gmqtt/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD BSD-2 ISC MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

src_compile() {
	GOBIN=${S}/bin CGO_ENABLED=0 go install ./... || die
}

src_install() {
	dobin bin/{gmqctl,gmqttd}
	keepdir /etc/${PN}
	systemd_dounit "${FILESDIR}/${PN}d.service"
	newinitd "${FILESDIR}/initd" "${PN}d"
	newconfd "${FILESDIR}/confd" "${PN}d"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotated" "${PN}"
	docompress -x /usr/share/doc/${PF}/default_config.yml
	dodoc CONTRIBUTING.md README*.md cmd/gmqttd/default_config.yml
	docinto federation
	dodoc -r plugin/federation/{examples,README.md}
}

pkg_postinst() {
	local config=/etc/gmqtt/gmqttd.yml dest=${ROOT}/
	if [[ ! ${REPLACING_VERSIONS} && ! -e ${ROOT}${config} ]]; then
		einfo "Copying default config to ${config} for first install"
		cp "${ROOT}/usr/share/doc/${PF}/default_config.yml" "${ROOT}${config}"
	fi
}
