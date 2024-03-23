# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="Kubernetes Node Agent"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="hardened selinux"

BDEPEND=">=dev-lang/go-1.20"
RDEPEND="selinux? ( sec-policy/selinux-kubernetes )"

RESTRICT+=" test "
S="${WORKDIR}/kubernetes-${PV}"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" FORCE_HOST_GO=yes \
	emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}
	keepdir /etc/kubernetes/manifests /var/log/kubelet /var/lib/kubelet
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto /etc/kubernetes
	newins "${FILESDIR}"/${PN}.env ${PN}.env
}
