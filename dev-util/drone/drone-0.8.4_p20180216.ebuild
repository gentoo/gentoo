# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone"
EGIT_COMMIT="ce3855812bb00dbf1993d8663b6100b272e104dd"
EGO_VENDOR=( "github.com/drone/drone-ui cc079b1279f70e54f64cf0c14e1e531b6689232b"
	"github.com/golang/protobuf bbd03ef6da3a115852eaf24c8a1c46aeb39aa175"
	"golang.org/x/net 92b859f39abd2d91a854c9f9c4621b2f5054a92d github.com/golang/net"
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
