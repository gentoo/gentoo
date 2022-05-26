# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/digitalocean/ceph_exporter
MY_PV="${PV}-nautilus"
# This inherit is deliberate since this version of ceph_exporter isn't a
# module.
inherit golang-vcs-snapshot

DESCRIPTION="Prometheus exporter that scrapes metrics from a ceph cluster"
HOMEPAGE="https://github.com/digitalocean/ceph_exporter"
SRC_URI="https://github.com/digitalocean/ceph_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/ceph
	acct-user/ceph
	=sys-cluster/ceph-15*
"
DEPEND="${RDEPEND}"

src_compile() {
	pushd src/${EGO_PN} > /dev/null || die
	GOPATH="${WORKDIR}/${P}" GO111MODULE=auto go build -o bin/ceph_exporter || die
}

src_install() {
	pushd src/${EGO_PN} > /dev/null || die
	dobin bin/ceph_exporter
	dodoc {README,CONTRIBUTING}.md exporter.yml
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/lib/ceph_exporter /var/log/ceph_exporter
	fowners ceph:ceph /var/lib/ceph_exporter /var/log/ceph_exporter
}
