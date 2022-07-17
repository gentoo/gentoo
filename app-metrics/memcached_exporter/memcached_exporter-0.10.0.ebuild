# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
GIT_COMMIT=667bdef45c4e01380867f4be5bb0c7e0ece35dd6

DESCRIPTION="Prometheus exporter for memcached"
HOMEPAGE="https://github.com/prometheus/memcached_exporter"
SRC_URI="https://github.com/prometheus/memcached_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/promu"
DEPEND="acct-group/memcached_exporter
	acct-user/memcached_exporter"
RDEPEND="${DEPEND}"

# tests require the memcached_exporter daemon to be running locally
RESTRICT+=" test "

src_prepare() {
	default
	sed -i \
		-e "s/{{.Branch}}/HEAD/" \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		.promu.yml || die "sed failed"
}

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc *.md
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
