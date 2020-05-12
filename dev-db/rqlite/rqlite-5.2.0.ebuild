# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
EGIT_COMMIT=77863e5a13110f1fca87b6fce84a7169c3aa58f5

DESCRIPTION="Replicated SQLite using the Raft consensus protocol"
HOMEPAGE="https://github.com/rqlite/rqlite http://www.philipotoole.com/tag/rqlite/"

EGO_SUM=(
	"github.com/Bowery/prompt v0.0.0-20190916142128-fa8279994f75"
	"github.com/Bowery/prompt v0.0.0-20190916142128-fa8279994f75/go.mod"
	"github.com/DataDog/datadog-go v2.2.0+incompatible/go.mod"
	"github.com/armon/go-metrics v0.0.0-20190430140413-ec5e00d3c878"
	"github.com/armon/go-metrics v0.0.0-20190430140413-ec5e00d3c878/go.mod"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/boltdb/bolt v1.3.1"
	"github.com/boltdb/bolt v1.3.1/go.mod"
	"github.com/circonus-labs/circonus-gometrics v2.3.1+incompatible/go.mod"
	"github.com/circonus-labs/circonusllhist v0.1.3/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/hashicorp/go-cleanhttp v0.5.0/go.mod"
	"github.com/hashicorp/go-hclog v0.9.1"
	"github.com/hashicorp/go-hclog v0.9.1/go.mod"
	"github.com/hashicorp/go-immutable-radix v1.0.0"
	"github.com/hashicorp/go-immutable-radix v1.0.0/go.mod"
	"github.com/hashicorp/go-msgpack v0.5.5"
	"github.com/hashicorp/go-msgpack v0.5.5/go.mod"
	"github.com/hashicorp/go-retryablehttp v0.5.3/go.mod"
	"github.com/hashicorp/go-uuid v1.0.0/go.mod"
	"github.com/hashicorp/golang-lru v0.5.0"
	"github.com/hashicorp/golang-lru v0.5.0/go.mod"
	"github.com/hashicorp/raft v1.1.0/go.mod"
	"github.com/hashicorp/raft v1.1.1"
	"github.com/hashicorp/raft v1.1.1/go.mod"
	"github.com/hashicorp/raft-boltdb v0.0.0-20171010151810-6e5ba93211ea/go.mod"
	"github.com/hashicorp/raft-boltdb v0.0.0-20191021154308-4207f1bf0617"
	"github.com/hashicorp/raft-boltdb v0.0.0-20191021154308-4207f1bf0617/go.mod"
	"github.com/labstack/gommon v0.3.0"
	"github.com/labstack/gommon v0.3.0/go.mod"
	"github.com/mattn/go-colorable v0.1.2/go.mod"
	"github.com/mattn/go-colorable v0.1.4"
	"github.com/mattn/go-colorable v0.1.4/go.mod"
	"github.com/mattn/go-isatty v0.0.8/go.mod"
	"github.com/mattn/go-isatty v0.0.9/go.mod"
	"github.com/mattn/go-isatty v0.0.11"
	"github.com/mattn/go-isatty v0.0.11/go.mod"
	"github.com/mattn/go-sqlite3 v2.0.2+incompatible"
	"github.com/mattn/go-sqlite3 v2.0.2+incompatible/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
	"github.com/mkideal/cli v0.0.3"
	"github.com/mkideal/cli v0.0.3/go.mod"
	"github.com/mkideal/pkg v0.0.0-20170503154153-3e188c9e7ecc"
	"github.com/mkideal/pkg v0.0.0-20170503154153-3e188c9e7ecc/go.mod"
	"github.com/pascaldekloe/goe v0.1.0/go.mod"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prometheus/client_golang v0.9.2/go.mod"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
	"github.com/prometheus/common v0.0.0-20181126121408-4724e9255275/go.mod"
	"github.com/prometheus/procfs v0.0.0-20181204211112-1dc9a6cbc91a/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/tv42/httpunix v0.0.0-20150427012821-b75d8614f926/go.mod"
	"github.com/valyala/bytebufferpool v1.0.0/go.mod"
	"github.com/valyala/fasttemplate v1.0.1/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191219195013-becbf705a915"
	"golang.org/x/crypto v0.0.0-20191219195013-becbf705a915/go.mod"
	"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190523142557-0e01d883c5c5/go.mod"
	"golang.org/x/sys v0.0.0-20190602015325-4c4f7f33c9ed"
	"golang.org/x/sys v0.0.0-20190602015325-4c4f7f33c9ed/go.mod"
	"golang.org/x/sys v0.0.0-20190813064441-fde4db37ae7a/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/rqlite/rqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT BSD MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_compile() {
	GOBIN="${S}/bin" \
		go install \
			-ldflags="-X main.version=v${PV}
				-X main.branch=master
				-X main.commit=${EGIT_COMMIT}
				-X main.buildtime=$(date +%Y-%m-%dT%T%z)" \
			./cmd/... || die
}

src_test() {
	GOBIN="${S}/bin" \
		go test ./... || die
}

src_install() {
	dobin bin/*
	dodoc -r *.md DOC
}
