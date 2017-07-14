# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone"
EGIT_COMMIT="f604d592bc356fcade4aec67eba9b7fba8eed655"
EGO_VENDOR=( "github.com/drone/drone-ui 2910d0ee662816a2463d31f0988b1ecccd0410b5" )

inherit golang-build golang-vcs-snapshot user

ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A Continuous Delivery platform built on Docker, written in Go"
HOMEPAGE="https://github.com/drone/drone"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-go/go-bindata
	dev-go/go-bindata-assetfs:="

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/drone ${PN}
}

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"\
		go install -ldflags "-extldflags '-static' -X github.com/drone/drone/version.VersionDev=build.${PV}.${EGIT_COMMIT:0:7}" ${EGO_PN}/drone || die
	popd || die
}

src_install() {
	newbin bin/drone drone-server
	dodoc src/github.com/drone/drone/README.md
	keepdir /var/log/drone /var/lib/drone
	fowners -R ${PN}:${PN} /var/log/drone /var/lib/drone
	newinitd "${FILESDIR}"/drone.initd drone
	newconfd "${FILESDIR}"/drone.confd drone
	newinitd "${FILESDIR}"/drone-agent.initd drone-agent
	newconfd "${FILESDIR}"/drone-agent.confd drone-agent
}
