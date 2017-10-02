# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone"
EGIT_COMMIT="8125f97c2147e9cae75aa793efe72048b8588297"
EGO_VENDOR=( "github.com/drone/drone-ui 5a497bd6cd5c3c17c53b00d40bcda1bf6f68f475"
	"github.com/golang/protobuf 130e6b02ab059e7b717a096f397c5b60111cae74"
	"golang.org/x/net 0a9397675ba34b2845f758fe3cd68828369c6517 github.com/golang/net"
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
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go build -ldflags "-extldflags '-static' -X github.com/drone/drone/version.VersionDev=build.${PV}.${EGIT_COMMIT:0:7}" -o release/drone-server ${EGO_PN}/cmd/drone-server || die
	GOPATH="${WORKDIR}/${P}" go build -ldflags "-X github.com/drone/drone/version.VersionDev=build.${PV}.${EGIT_COMMIT:0:7}" -o release/drone-agent ${EGO_PN}/cmd/drone-agent || die
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
