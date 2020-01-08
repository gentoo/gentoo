# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="github.com/cloudnativelabs/${PN}"

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"

DESCRIPTION="A turnkey solution for Kubernetes networking"
HOMEPAGE="https://kube-router.io"
SRC_URI="https://github.com/cloudnativelabs/kube-router/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	net-firewall/iptables[conntrack]
	net-firewall/ipset
	sys-cluster/ipvsadm
"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -x -work -v \
		-ldflags "-X 'github.com/cloudnativelabs/kube-router/pkg/cmd.version=${PV}' "\
"-X 'github.com/cloudnativelabs/kube-router/pkg/cmd.buildDate=$(date -u +%FT%T%z)'" \
		-o kube-router cmd/kube-router/kube-router.go || die
	popd || die
}

src_test() {
	:
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin ${PN}
	dodoc *.md docs/*.md docs/*/*
	popd || die

	newinitd "${FILESDIR}"/kube-router.initd kube-router
	newconfd "${FILESDIR}"/kube-router.confd kube-router

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/kube-router.logrotated kube-router
}
