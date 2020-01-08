# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit user golang-build golang-vcs-snapshot systemd

EGO_PN="github.com/prometheus/pushgateway"
EGIT_COMMIT="v${PV/_rc/-rc.}"
GIT_COMMIT="cc61f46"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus push acceptor for ephemeral and batch jobs"
HOMEPAGE="https://github.com/prometheus/pushgateway"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.12
	>=dev-util/promu-0.3.0"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${GIT_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #672926
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GO111MODULE=on GOPATH="${S}" promu build -v --prefix bin || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/pushgateway
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	popd || die
	keepdir /var/lib/${PN} /var/log/${PN}
	fowners ${PN}:${PN} /var/lib/${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-1.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}-1.service"
}
