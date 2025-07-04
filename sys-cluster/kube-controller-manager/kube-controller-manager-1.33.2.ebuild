# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Kubernetes Controller Manager"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"
S=${WORKDIR}/kubernetes-${PV}

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="hardened"
RESTRICT="test"

DEPEND="acct-group/kube-controller-manager
	acct-user/kube-controller-manager"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.24.0"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		emake -j1 GOFLAGS="${GOFLAGS}" GOLDFLAGS="" LDFLAGS="" FORCE_HOST_GO=yes \
		WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
