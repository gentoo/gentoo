# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd
GIT_COMMIT=c34ff3d6b4817f42e74b2b05b3797cf99683b4a9

DESCRIPTION="Prometheus exporter for BIND"
HOMEPAGE="https://github.com/prometheus-community/bind_exporter"
SRC_URI="
	https://github.com/prometheus-community/bind_exporter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~robbat2/distfiles/bind_exporter-${PV}-vendor.tar.xz
	"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/bind_exporter
	acct-user/bind_exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i -e "/-s$/d" -e "s/{{.Revision}}/${GIT_COMMIT}/" .promu.yml || die
}

src_compile() {
	mkdir -p bin || die
	promu build -v --prefix bin || die
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
