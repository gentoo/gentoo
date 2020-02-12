# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Kubernetes Controller Manager"
HOMEPAGE="https://github.com/kubernetes/kubernetes https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/kube-controller-manager
	acct-user/kube-controller-manager"
DEPEND="${COMMON_DEPEND}
	dev-go/go-bindata
	>=dev-lang/go-1.13"
	RDEPEND="${COMMON_DEPEND}"

RESTRICT="test"
S="${WORKDIR}/kubernetes-${PV}"

src_prepare() {
	default
	sed -i -e "/vendor\/github.com\/jteeuwen\/go-bindata\/go-bindata/d" -e "s/-s -w/-w/" hack/lib/golang.sh || die
	sed -i -e "/export PATH/d" hack/generate-bindata.sh || die
}

src_compile() {
	LDFLAGS="" emake -j1 WHAT=cmd/${PN} GOFLAGS=-v
}

src_install() {
	dobin _output/bin/${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
}
