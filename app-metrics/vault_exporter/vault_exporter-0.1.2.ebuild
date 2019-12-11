# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

MY_PV=${PV/_/}

EGO_PN="github.com/grapeshot/vault_exporter"
ARCHIVE_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Vault exporter for Prometheus"
HOMEPAGE="https://github.com/grapeshot/vault_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" emake build
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	newbin _output/bin/vault_exporter-v${PV}* vault_exporter
	dodoc README.md
	popd || die
	keepdir /var/log/vault_exporter
	fowners ${PN}:${PN} /var/log/vault_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
