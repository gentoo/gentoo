# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/rqlite/rqlite"
EGO_VENDOR=(
	"github.com/Bowery/prompt fa8279994f75f982bdae3c827a3afffd78a6fe0d"
	"github.com/armon/go-metrics v0.3.0"
	"github.com/boltdb/bolt v1.3.1"
	"github.com/hashicorp/go-immutable-radix v1.1.0"
	"github.com/hashicorp/go-msgpack v0.5.5"
	"github.com/hashicorp/golang-lru v0.5.3"
	"github.com/labstack/gommon v0.3.0"
	"github.com/mattn/go-colorable v0.1.4"
	"github.com/mattn/go-isatty v0.0.10"
	"github.com/mattn/go-sqlite3 v1.13.0"
	"github.com/mkideal/cli v0.0.3"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/crypto b544559bb6d1b5c62fba4af5e843ff542174f079 github.com/golang/crypto"
	"golang.org/x/sys 6d18c012aee9febd81bbf9806760c8c4480e870d github.com/golang/sys"
)

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Replicated SQLite using the Raft consensus protocol"

HOMEPAGE="https://github.com/rqlite/rqlite http://www.philipotoole.com/tag/rqlite/"
LICENSE="MIT BSD MPL-2.0"
SLOT="0"
IUSE=""
EGIT_REPO_URI="https://${EGO_PN}.git"
EGIT_COMMIT="085d2d23d88728fbf03855f4fd213815397ed9f4"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678966
	GOPATH="${WORKDIR}/${P}" \
	GOBIN="${WORKDIR}/${P}/bin" \
		go install \
			-ldflags="-X main.version=v${PV} -X main.branch=master -X main.commit=${EGIT_COMMIT} -X main.buildtime=$(date +%Y-%m-%dT%T%z)" \
			-v -work -x ${EGO_BUILD_FLAGS} ${EGO_PN}/cmd/... || die
}

src_test() {
	GOPATH="${WORKDIR}/${P}" \
	GOBIN="${WORKDIR}/${P}/bin" \
		go test -v ./... || die
}

src_install() {
	dobin "${WORKDIR}/${P}/bin"/${PN}{,d}
	dodoc -r *.md DOC
}
