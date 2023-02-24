# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Prometheus exporter that scrapes metrics from a ceph cluster"
HOMEPAGE="https://github.com/digitalocean/ceph_exporter"
SRC_URI="https://github.com/digitalocean/ceph_exporter/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/ceph
	acct-user/ceph
	=sys-cluster/ceph-16*
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-lang/go-1.18"

src_compile() {
	go build -o bin/ceph_exporter || die
}

src_install() {
	dobin bin/ceph_exporter
	dodoc {README,CONTRIBUTING}.md exporter.yml
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/lib/ceph_exporter /var/log/ceph_exporter
	fowners ceph:ceph /var/lib/ceph_exporter /var/log/ceph_exporter
}
