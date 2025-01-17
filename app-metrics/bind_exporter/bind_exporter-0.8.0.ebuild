# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo go-module systemd

GIT_COMMIT=5cc1b62b9c866184193007a0f7ec3b2eb31460bf

DESCRIPTION="Prometheus exporter for BIND"
HOMEPAGE="https://github.com/prometheus-community/bind_exporter"
SRC_URI="
	https://github.com/prometheus-community/bind_exporter/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-metrics/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/bind_exporter
	acct-user/bind_exporter
"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i .promu.yml -e "s/{{.Revision}}/${GIT_COMMIT}/" || die
}

src_compile() {
	mkdir -p bin || die
	edo promu build -v --prefix bin
}

src_test() {
	emake test-flags= test
}

src_install() {
	dobin bin/${PN}
	dodoc {README,CHANGELOG}.md

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
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
