# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rqlite/rqlite"
EGO_VENDOR=(
	"github.com/Bowery/prompt 8a1d5376df1cbec3468f2138fecc44dd8b48e342"
	"github.com/armon/go-metrics f0300d1749da6fa982027e449ec0c7a145510c3c"
	"github.com/boltdb/bolt fd01fc79c553a8e99d512a07e8e0c63d4a3ccfc5"
	"github.com/hashicorp/go-immutable-radix 27df80928bb34bb1b0d6d0e01b9e679902e7a6b5"
	"github.com/hashicorp/go-msgpack 2e9170ac1d8fb32e1e645d8364e4d8f21b530bb3"
	"github.com/hashicorp/golang-lru 20f1fb78b0740ba8c3cb143a61e86ba5c8669768"
	"github.com/labstack/gommon 34167a09256a4fcb5d26dd88d02b7b353d86838a"
	"github.com/mattn/go-colorable efa589957cd060542a26d2dd7832fd6a6c6c3ade"
	"github.com/mattn/go-isatty 3fb116b820352b7f0c281308a4d6250c22d94e27"
	"github.com/mattn/go-sqlite3 3fa1c550ffa69b74dc4bfd5109b4e218f32c87cf"
	"github.com/mkideal/cli a48c2cee5b5ee91096961d344681edc2083b9422"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/crypto 64072686203f69e3fd20143576b27200f18ab0fa github.com/golang/crypto"
	"golang.org/x/sys 054c452bb702e465e95ce8e7a3d9a6cf0cd1188d github.com/golang/sys"
)

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Replicated SQLite using the Raft consensus protocol"

HOMEPAGE="https://github.com/rqlite/rqlite http://www.philipotoole.com/tag/rqlite/"
LICENSE="MIT"
SLOT="0"
IUSE=""
EGIT_REPO_URI="https://${EGO_PN}.git"
EGIT_COMMIT="77e345b97c5597c1ef86e75e690539de369b8dd3"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	GOPATH="${WORKDIR}/${P}" \
	GOBIN="${WORKDIR}/${P}/bin" \
		go install \
			-ldflags="-X main.version=v${PV} -X main.branch=master -X main.commit=${EGIT_COMMIT} -X main.buildtime=$(date +%Y-%m-%dT%T%z)" \
			-v -work -x ${EGO_BUILD_FLAGS} ${EGO_PN}/cmd/... || die
}

src_install() {
	dobin "${WORKDIR}/${P}/bin"/${PN}{,d}
	dodoc -r *.md DOC
}
