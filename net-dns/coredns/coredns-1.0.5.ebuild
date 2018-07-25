# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/mholt/caddy 9619fe224c96d0c4a060e83badbf95b6bd69a0ac"
	"github.com/miekg/dns 5364553f1ee9cddc7ac8b62dce148309c386695b"
	"github.com/prometheus/client_golang e69720d204a4aa3b0c65dc91208645ba0a52b9cd"
	"github.com/beorn7/perks 4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9"
	"github.com/prometheus/procfs 282c8707aa210456a825798969cc27edda34992a"
	"golang.org/x/net cbe0f9307d0156177f9dd5dc85da1a31abc5f2fb github.com/golang/net"
	"golang.org/x/text 9e2b64d659da1afe07ce1c9c1dfefc09d188f21e github.com/golang/text"
)

EGO_PN="github.com/${PN}/${PN}"

inherit golang-build golang-vcs-snapshot

GITCOMMIT="ea95a2003a710b9057d7500bdca38f6394896294"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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
	GOPATH="${S}" go build -v -ldflags="-X github.com/coredns/coredns/coremain.GitCommit=${GITCOMMIT}" || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN}
	dobin ${PN}
	dodoc README.md
	popd || die
}
