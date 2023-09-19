# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot systemd

ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
EGIT_COMMIT="v${PV/_rc/-rc.}"
EGO_PN="github.com/timonwong/uwsgi_exporter"
UWSGI_EXPORTER_COMMIT="ddbc18f"

DESCRIPTION="uWSGI metrics exporter for prometheus.io"
HOMEPAGE="https://github.com/timonwong/uwsgi_exporter"
SRC_URI="${ARCHIVE_URI}"

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
	sed -e "s/{{.Revision}}/${UWSGI_EXPORTER_COMMIT}/" -i src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix bin || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/uwsgi_exporter
	dodoc README.md
	popd || die
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
