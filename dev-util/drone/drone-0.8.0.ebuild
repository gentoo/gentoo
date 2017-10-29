# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone"
EGIT_COMMIT="ec6016062bd1d7d702c5edf383eb0728df33dbdd"
EGO_VENDOR=( "github.com/drone/drone-ui 87c64622eae0ea8d515fa6d551841d4b699bf7f1"
	"github.com/golang/protobuf 130e6b02ab059e7b717a096f397c5b60111cae74"
	"golang.org/x/net 0744d001aa8470aaa53df28d32e5ceeb8af9bd70 github.com/golang/net"
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
