# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build user

EGO_PN=github.com/prometheus/memcached_exporter
DESCRIPTION="Prometheus exporter for memcached"
HOMEPAGE="https://github.com/prometheus/memcached_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/promu"

RESTRICT="strip"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	mkdir -p "${HOME}/go/src/${EGO_PN%/*}" || die "mkdir failed"
	ln -snf "${S}" "${HOME}/go/src/${EGO_PN}" || die "ln failed"
	default
}

src_compile() {
	# needed since we use the default GOPATH
	unset GOPATH
	mkdir -p bin || die
	promu build -v --prefix bin || die
}

src_install() {
	newbin bin/${P} ${PN}
	dodoc *.md
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
