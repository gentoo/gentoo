# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/dustin/go-humanize 259d2a102b871d17f30e3cd9881a642961a1e486"
	"github.com/flynn/go-shlex 3f9db97f856818214da2e1057f8ad84803971cff"
	"github.com/xenolf/lego 5dfe609afb1ebe9da97c9846d97a55415e5a5ccd"
	"github.com/lucas-clemente/quic-go-certificates d2f86524cced5186554df90d92529757d22c1cb6"
	"github.com/lucas-clemente/quic-go 61f5f1e66861b725f31c7da25eccf59abfe2fd94"
	"github.com/gorilla/websocket a91eba7f97777409bc2c443f5534d41dd20c5720"
	"github.com/miekg/dns 6ebcb714d36901126ee2807031543b38c56de963"
	"github.com/hashicorp/go-syslog b609c7d9de4658cded34a7336b90886c56f9dbdb"
	"github.com/jimstudt/http-authentication 3eca13d6893afd7ecabe15f4445f5d2872a1b012"
	"github.com/naoina/toml ac014c6b6502388d89a85552b7208b8da7cfe104"
	"github.com/hashicorp/golang-lru 0a025b7e63adc15a622f29b0b2c4c3848243bbf6"
	"github.com/lucas-clemente/aes12 25700e67be5c860bcc999137275b9ef8b65932bd"
	"github.com/lucas-clemente/fnv128a 393af48d391698c6ae4219566bfbdfef67269997"
	"github.com/naoina/go-stringutil 6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
	"github.com/russross/blackfriday b253417e1cb644d645a0a3bb1fa5034c8030127c"
	"github.com/shurcooL/sanitized_anchor_name 1dba4b3954bc059efc3991ec364f9f9a35f597d2"
	"golang.org/x/net c8c74377599bd978aee1cf3b9b63a8634051cec2 github.com/golang/net"
	"golang.org/x/crypto 96846453c37f0876340a66a47f3f75b1f3a6cd2d github.com/golang/crypto"
	"golang.org/x/text 19e3104b43db45fca0303f489a9536087b184802 github.com/golang/text"
	"gopkg.in/natefinch/lumberjack.v2 dd45e6a67c53f673bb49ca8a001fd3a63ceb640e github.com/natefinch/lumberjack"
	"gopkg.in/square/go-jose.v1 bd0247f8b50d7aa466c4a140dd4ce7a1419cdba4 github.com/square/go-jose"
	"gopkg.in/yaml.v2 cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b github.com/go-yaml/yaml" )

EGO_PN="github.com/mholt/${PN}/..."

inherit golang-build golang-vcs-snapshot

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://github.com/mholt/caddy"

SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.8"

RESTRICT="test"

src_compile() {
	GOPATH="${WORKDIR}/${P}" go install -ldflags "-X github.com/mholt/caddy/caddy/caddymain.gitTag=${PV}" ${EGO_PN%/*}/caddy || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN%/*}/README.md src/${EGO_PN%/*}/dist/CHANGES.txt
}
