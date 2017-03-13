# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/dustin/go-humanize 7a41df006ff9af79a29f0ffa9c5f21fbe6314a2d"
	"github.com/flynn/go-shlex 3f9db97f856818214da2e1057f8ad84803971cff github.com/flynn-archive/go-shlex"
	"github.com/xenolf/lego 6cac0ea7d8b28c889f709ec7fa92e92b82f490dd"
	"github.com/lucas-clemente/quic-go-certificates d2f86524cced5186554df90d92529757d22c1cb6"
	"github.com/lucas-clemente/quic-go 178c14f1d482f6f5f1d22147fef2dd01cce35cb4"
	"github.com/gorilla/websocket 3f3e394da2b801fbe732a935ef40724762a67a07"
	"github.com/miekg/dns eda6b320244f0700772bb765282381d17495e7d3"
	"github.com/hashicorp/go-syslog b609c7d9de4658cded34a7336b90886c56f9dbdb"
	"github.com/jimstudt/http-authentication 3eca13d6893afd7ecabe15f4445f5d2872a1b012"
	"github.com/naoina/toml 751171607256bb66e64c9f0220c00662420c38e9"
	"github.com/hashicorp/golang-lru 0a025b7e63adc15a622f29b0b2c4c3848243bbf6"
	"github.com/lucas-clemente/aes12 25700e67be5c860bcc999137275b9ef8b65932bd"
	"github.com/lucas-clemente/fnv128a 393af48d391698c6ae4219566bfbdfef67269997"
	"github.com/naoina/go-stringutil 6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
	"github.com/russross/blackfriday 5f33e7b7878355cd2b7e6b8eefc48a5472c69f70"
	"github.com/shurcooL/sanitized_anchor_name 1dba4b3954bc059efc3991ec364f9f9a35f597d2"
	"golang.org/x/net 906cda9512f77671ab44f8c8563b13a8e707b230 github.com/golang/net"
	"golang.org/x/crypto 453249f01cfeb54c3d549ddb75ff152ca243f9d8 github.com/golang/crypto"
	"gopkg.in/natefinch/lumberjack.v2 dd45e6a67c53f673bb49ca8a001fd3a63ceb640e github.com/natefinch/lumberjack"
	"gopkg.in/square/go-jose.v1 aa2e30fdd1fe9dd3394119af66451ae790d50e0d github.com/square/go-jose"
	"gopkg.in/yaml.v2 a3f3340b5840cee44f372bddb5880fcbc419b46a github.com/go-yaml/yaml" )

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

RESTRICT="test"

src_compile() {
	GOPATH="${WORKDIR}/${P}" go install -ldflags "-X github.com/mholt/caddy/caddy/caddymain.gitTag=${PV}" ${EGO_PN%/*}/caddy || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN%/*}/README.md src/${EGO_PN%/*}/dist/CHANGES.txt
}
