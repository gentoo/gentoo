# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/grapeshot/vault_exporter"
MY_PV="${PV/_/}"

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Vault exporter for Prometheus"
HOMEPAGE="https://github.com/grapeshot/vault_exporter"
SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/vault_exporter
	acct-user/vault_exporter
"

BDEPEND="${RDEPEND}"

src_compile() {
	pushd "src/${EGO_PN}" || die
	GOPATH="${S}" emake build
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	newbin _output/bin/vault_exporter-v${PV}* vault_exporter
	dodoc README.md
	popd || die

	keepdir /var/log/vault_exporter
	fowners vault_exporter:vault_exporter /var/log/vault_exporter

	newinitd "${FILESDIR}"/vault_exporter.initd vault_exporter
	newconfd "${FILESDIR}"/vault_exporter.confd vault_exporter
}
