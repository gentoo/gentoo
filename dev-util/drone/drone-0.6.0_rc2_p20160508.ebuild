# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone/..."
EGIT_COMMIT="3c6613a430dab87371848442acc19e634835b9d1"
EGO_VENDOR=( "github.com/drone/drone-ui f4c434d13c88da905d895156850e721cd4bd89af" )

inherit golang-build golang-vcs-snapshot user

ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
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

pkg_setup() {
	enewgroup drone
	enewuser drone -1 -1 /var/lib/drone drone
}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"	emake -C src/github.com/drone/drone gen || die
	pushd src || die
	DRONE_BUILD_NUMBER="${EGIT_COMMIT:0:7}" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"\
		go install -ldflags "-extldflags '-static' -X github.com/drone/drone/version.VersionDev=build.${EGIT_COMMIT:0:7}" github.com/drone/drone/drone || die
	popd || die
}

src_install() {
	dobin bin/*
	dodoc src/github.com/drone/drone/README.md
	keepdir /var/log/drone /var/lib/drone
	fowners -R drone:drone /var/log/drone /var/lib/drone
	newinitd "${FILESDIR}"/drone.initd drone
	newconfd "${FILESDIR}"/drone.confd drone
	newinitd "${FILESDIR}"/drone-agent.initd drone-agent
	newconfd "${FILESDIR}"/drone-agent.confd drone-agent
}
