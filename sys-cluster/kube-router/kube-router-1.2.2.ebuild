# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A turnkey solution for Kubernetes networking"
HOMEPAGE="https://kube-router.io"
SRC_URI="https://github.com/cloudnativelabs/kube-router/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT BSD BSD-2 MPL-2.0 ISC LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	net-firewall/iptables[conntrack]
	net-firewall/ipset
	sys-cluster/ipvsadm
"

src_compile() {
	emake BUILD_IN_DOCKER=false GIT_COMMIT=v${PV} kube-router
}

src_test() {
	go test -mod=vendor -v -timeout=30s ./cmd/kube-router ./pkg/... ||
		die "tests failed"
}

src_install() {
	dobin "${PN}"
	einstalldocs
	newinitd "${FILESDIR}"/kube-router.initd kube-router
	newconfd "${FILESDIR}"/kube-router.confd kube-router
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/kube-router.logrotated kube-router
}
