# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/mholt/caddy b33b24fc9e9d50ce73ec386e44c316d70c47642c"
	"github.com/miekg/dns d174bbf0a57b4ab555db36b0e55f692d5e8dfca8"
	"github.com/prometheus/client_golang f504d69affe11ec1ccb2e5948127f86878c9fd57"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/prometheus/procfs 780932d4fbbe0e69b84c34c20f5c8d0981e109ea"
	"golang.org/x/net b68f30494add4df6bd8ef5e82803f308e7f7c59c github.com/golang/net"
	"golang.org/x/text ece95c760240037f89ebcbdd7155ac8cb52e38fa github.com/golang/text"
)

EGO_PN="github.com/${PN}/${PN}"

inherit golang-build golang-vcs-snapshot

GITCOMMIT="231c2c0ef3fb921f5cae31ff4a2f7c6653da01ad"
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
