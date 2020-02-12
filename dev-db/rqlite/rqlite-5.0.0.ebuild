# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

KEYWORDS="~amd64"
DESCRIPTION="Replicated SQLite using the Raft consensus protocol"

HOMEPAGE="https://github.com/rqlite/rqlite http://www.philipotoole.com/tag/rqlite/"
LICENSE="MIT BSD MPL-2.0"
SLOT="0"
IUSE=""

EGIT_COMMIT="dd61a7a221bc3f8b0841dc298cdccc4fe4a81c6b"

EGO_VENDOR=(
	"github.com/Bowery/prompt fa8279994f75f982bdae3c827a3afffd78a6fe0d"
	"github.com/armon/go-metrics ec5e00d3c878b2a97bbe0884ef45ffd1b4f669f5"
	"github.com/boltdb/bolt v1.3.1"
	"github.com/hashicorp/go-hclog v0.9.1"
	"github.com/hashicorp/go-immutable-radix v1.0.0"
	"github.com/hashicorp/go-msgpack v0.5.5"
	"github.com/hashicorp/golang-lru v0.5.0"
	"github.com/hashicorp/raft v1.1.1"
	"github.com/hashicorp/raft-boltdb 4207f1bf061751378aee6cdfe697965a13ab49d7"
	"github.com/labstack/gommon v0.3.0"
	"github.com/mattn/go-colorable v0.1.4"
	"github.com/mattn/go-isatty v0.0.11"
	"github.com/mattn/go-sqlite3 v2.0.2"
	"github.com/mkideal/cli v0.0.3"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/crypto becbf705a91575484002d598f87d74f0002801e7 github.com/golang/crypto"
	"golang.org/x/sys 33540a1f603772f9d4b761f416f5c10dade23e96 github.com/golang/sys"
)

SRC_URI="https://github.com/rqlite/rqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #678966
	GOBIN="${S}/bin" \
		go install \
			-ldflags="-X main.version=v${PV} -X main.branch=master -X main.commit=${EGIT_COMMIT} -X main.buildtime=$(date +%Y-%m-%dT%T%z)" \
			-v -work -x ./cmd/... || die
}

src_test() {
	GOBIN="${S}/bin" \
		go test ./... || die
}

src_install() {
	dobin bin/*
	dodoc -r *.md DOC
}
