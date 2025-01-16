# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module
MY_PV="${PV/_/}"

DESCRIPTION="Vault exporter for Prometheus"
HOMEPAGE="https://github.com/talend/vault_exporter"
SRC_URI="https://github.com/talend/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/vault_exporter
	acct-user/vault_exporter
"

BDEPEND="${RDEPEND}"

src_compile() {
	ego build -ldflags '-d -s -w' -tags netgo -installsuffix netgo -v -x .
}

src_install() {
	dobin ${PN}
	dodoc *.md
	insinto /usr/share/${PN}
	doins -r vault-mixin
	newinitd "${FILESDIR}"/vault_exporter.initd vault_exporter
	newconfd "${FILESDIR}"/vault_exporter.confd vault_exporter
	keepdir /var/log/vault_exporter
	fowners vault_exporter:vault_exporter /var/log/vault_exporter
}
