# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGO_PN="github.com/drone/drone/..."
EGIT_COMMIT="dc5f01d00ec2970fe881c6633fbf69f6f0cb8950"
EGO_VENDOR=( "github.com/drone/mq 280af2a3b9c7d9ce90d625150dfff972c6c190b8"
	"github.com/tidwall/redlog 550629ebbfa9925a73f69cce7cdd2e8dae52c713"
	"golang.org/x/crypto 728b753d0135da6801d45a38e6f43ff55779c5c2 github.com/golang/crypto" )

inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A Continuous Delivery platform built on Docker, written in Go"
HOMEPAGE="https://github.com/drone/drone"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-go/go-bindata
	dev-go/go-bindata-assetfs:=
	dev-util/drone-ui:="

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"	emake -C src/github.com/drone/drone gen || die
	pushd src || die
	DRONE_BUILD_NUMBER="${EGIT_COMMIT:0:7}" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)"\
		go install -ldflags "-extldflags '-static' -X github.com/drone/drone/version.VersionDev=${EGIT_COMMIT:0:7}" github.com/drone/drone/drone || die
	popd || die
}

src_install() {
	dobin bin/*
}
