# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/coreos/zetcd"

EGO_VENDOR=( "github.com/coreos/etcd fa4903c83c72f2857b8ed795a3c86f140b89d52c" )

inherit golang-build golang-vcs-snapshot user

ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A ZooKeeper personality for etcd"
HOMEPAGE="https://github.com/coreos/zetcd"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}" go install ${EGO_PN}/cmd/... || die
	popd || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN}/README.md
	keepdir /var/log/zetcd
	fowners -R ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
