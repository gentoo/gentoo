# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone"
EGIT_COMMIT="81103a98208b0bfc76be5b07194f359fbc80183b"
EGO_VENDOR=( "github.com/drone/drone-ui 4d60e46e3938c277e90de404cc6236530beaab3d"
	"github.com/golang/protobuf e09c5db296004fbe3f74490e84dcd62c3c5ddb1b"
	"golang.org/x/net 6078986fec03a1dcc236c34816c71b0e05018fda github.com/golang/net"
	)

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
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go build -v -ldflags "-extldflags '-static' -X github.com/drone/drone/version.VersionDev=build.${PV}.${EGIT_COMMIT:0:7}" -o release/drone-server ${EGO_PN}/cmd/drone-server || die
	GOPATH="${WORKDIR}/${P}" go build -v -ldflags "-X github.com/drone/drone/version.VersionDev=build.${PV}.${EGIT_COMMIT:0:7}" -o release/drone-agent ${EGO_PN}/cmd/drone-agent || die
	popd || die
}

src_install() {
	dobin src/release/drone-{agent,server}
	dodoc src/github.com/drone/drone/README.md
	keepdir /var/log/drone /var/lib/drone
	fowners -R ${PN}:${PN} /var/log/drone /var/lib/drone
	newinitd "${FILESDIR}"/drone-server.initd drone-server
	newconfd "${FILESDIR}"/drone-server.confd drone-server
	newinitd "${FILESDIR}"/drone-agent.initd drone-agent
	newconfd "${FILESDIR}"/drone-agent.confd drone-agent
}
