# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

SRC_URI="https://github.com/timonwong/uwsgi_exporter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"
UWSGI_EXPORTER_COMMIT="f04f713"

DESCRIPTION="uWSGI metrics exporter for prometheus.io"
HOMEPAGE="https://github.com/timonwong/uwsgi_exporter"

LICENSE="Apache-2.0 BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/uwsgi_exporter
	acct-user/uwsgi_exporter
"

DEPEND="
	${RDEPEND}
	dev-util/promu
"

src_prepare() {
	default
	sed -e "s/{{.Revision}}/${UWSGI_EXPORTER_COMMIT}/" -i "${S}/.promu.yml" || die
}

src_compile() {
	mkdir -p bin || die
	GO111MODULE=on promu build -v --prefix bin || die
}

src_install() {
	newbin bin/${P} uwsgi_exporter
	dodoc README.md
	local dir
	for dir in /var/log/${PN}; do
		keepdir "${dir}"
		fowners ${PN}:${PN} "${dir}"
	done
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}
