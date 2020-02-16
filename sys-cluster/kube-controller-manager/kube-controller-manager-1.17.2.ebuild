# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module user

DESCRIPTION="Kubernetes Controller Manager"
HOMEPAGE="https://github.com/kubernetes/kubernetes https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-go/go-bindata
	>=dev-lang/go-1.13"

RESTRICT="test"
S="${WORKDIR}/kubernetes-${PV}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

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
