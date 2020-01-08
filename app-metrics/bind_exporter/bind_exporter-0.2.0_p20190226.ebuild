# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/digitalocean/bind_exporter"
EXPORTER_COMMIT="9289b40af62a455ebd587ed4701dd543f4cc5877"
ARCHIVE_URI="https://${EGO_PN}/archive/${EXPORTER_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for BIND"
HOMEPAGE="https://github.com/digitalocean/bind_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "/-s$/d" -e "s/{{.Revision}}/${EXPORTER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix bin || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/${PN}
	dodoc {README,CHANGELOG}.md
	popd || die
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_postinst() {
	elog "Make sure BIND was built with libxml2 support. You can check with the"
	elog "following command: named -V | grep libxml2."
	elog "Configure BIND to open a statistics channel. It's recommended to run"
	elog "the bind_exporter next to BIND, so it's only necessary to open a port"
	elog "locally."
	elog ""
	elog "statistics-channels {"
	elog "inet 127.0.0.1 port 8053 allow { 127.0.0.1; };"
	elog "};"
}
