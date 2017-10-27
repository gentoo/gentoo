# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/mholt/caddy c4dfbb9956095c92d0586a52723748c070c7b459"
	"github.com/miekg/dns 822ae18e7187e1bbde923a37081f6c1b8e9ba68a"
	"golang.org/x/net c73622c77280266305273cb545f54516ced95b93 github.com/golang/net"
	"golang.org/x/text 6eab0e8f74e86c598ec3b6fad4888e0c11482d48 github.com/golang/text" )

EGO_PN="github.com/${PN}/${PN}"

inherit golang-build golang-vcs-snapshot

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN}
	dobin ${PN}
	dodoc README.md
	popd || die
}
