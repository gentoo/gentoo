# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/drone/drone"
EGIT_COMMIT="3daf6797ab6378d4a27b9fb1d4877e3a55a6c922"
EGO_VENDOR=( "github.com/drone/drone-ui cc079b1279f70e54f64cf0c14e1e531b6689232b"
	"github.com/golang/protobuf 1e59b77b52bf8e4b449a57e6f79f21226d571845"
	"golang.org/x/net a8b9294777976932365dabb6640cf1468d95c70f github.com/golang/net"
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
