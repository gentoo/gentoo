# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/bcicen/${PN}/..."
EGIT_COMMIT="5db90f31dcfed7dbd1473d771ba72c08e5b28ec7"
EGO_VENDOR=( "github.com/fsouza/go-dockerclient 87c7e50e0bcf800ed863c3c3b0fbcc67e3029140"
	"github.com/docker/docker c5f178da05b27bda40c863b7d65ef8ef11eb1fbe"
	"github.com/docker/go-units 0dadbb0345b35ec7ef35e228dabb8de89a65bf52"
	"github.com/gizak/termui ea10e6ccee219e572ffad0ac1909f1a17f6db7d6 github.com/bcicen/termui"
	"github.com/hashicorp/go-cleanhttp 3573b8b52aa7b37b9358d966a898feb387f62437"
	"github.com/jgautheron/codename-generator 16d037c7cc3c9b552fe4af9828b7338d752dbaf9"
	"github.com/maruel/panicparse 25bcac0d793cf4109483505a0d66e066a3a90a80"
	"github.com/mattn/go-runewidth 14207d285c6c197daabb5c9793d63e7af9ab2d50"
	"github.com/mitchellh/go-wordwrap ad45545899c7b13c020ea92b2072220eefad42b8"
	"github.com/nsf/termbox-go 7994c181db7761ca3c67a217068cf31826113f5f"
	"github.com/op/go-logging 970db520ece77730c7e4724c61121037378659d9"
	"github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
	"golang.org/x/net 6c23252515492caf9b228a9d5cabcdbde29f7f82 github.com/golang/net" )

inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Top-like interface for container-metrics"
HOMEPAGE="https://ctop.sh https://github.com/bcicen/ctop"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="MIT"
SLOT="0"
IUSE="hardened"

RESTRICT="test"

src_compile() {
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	pushd src/${EGO_PN%/*} || die
	GOPATH="${WORKDIR}/${P}"\
		go build -tags release -ldflags "-X main.version=${PV} -X main.build=${EGIT_COMMIT:0:7}" -o ${PN} || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dobin ${PN}
	dodoc README.md
	popd || die
}
