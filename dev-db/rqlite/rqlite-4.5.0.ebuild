# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/rqlite/rqlite"
EGO_VENDOR=(
	"github.com/Bowery/prompt 972d0ceb96f55132a1ba9714cb771ce19b3821ab"
	"github.com/armon/go-metrics 2801d9688273d5b516966851b9a0863b9e6b0652"
	"github.com/boltdb/bolt fd01fc79c553a8e99d512a07e8e0c63d4a3ccfc5"
	"github.com/hashicorp/go-immutable-radix 27df80928bb34bb1b0d6d0e01b9e679902e7a6b5"
	"github.com/hashicorp/go-msgpack c4a1f61d43c2788b8b6fd55304f01a96863eec94"
	"github.com/hashicorp/golang-lru 7087cb70de9f7a8bc0a10c375cb0d2280a8edf9c"
	"github.com/labstack/gommon 82ef680aef5189b68682876cf70d09daa4ac0f51"
	"github.com/mattn/go-colorable 3a70a971f94a22f2fa562ffcc7a0eb45f5daf045"
	"github.com/mattn/go-isatty c1975dc15c1d481e8da23f6ed313bb071136b98f"
	"github.com/mattn/go-sqlite3 5994cc52dfa89a4ee21ac891b06fbc1ea02c52d3"
	"github.com/mkideal/cli 41df2d00b0edfa4614da67cf68f41df9d4e55539"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/crypto c05e17bb3b2dca130fc919668a96b4bec9eb9442 github.com/golang/crypto"
	"golang.org/x/sys 9f0b1ff7b46a4014ddb5d4bdb6602a43b882cb27 github.com/golang/sys"
)

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Replicated SQLite using the Raft consensus protocol"

HOMEPAGE="https://github.com/rqlite/rqlite http://www.philipotoole.com/tag/rqlite/"
LICENSE="MIT"
SLOT="0"
IUSE=""
EGIT_REPO_URI="https://${EGO_PN}.git"
EGIT_COMMIT="8336150318dfb2b1f196f6a4919041b65071f3fd"
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
