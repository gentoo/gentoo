# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rqlite/rqlite"
EGO_VENDOR=(
	"github.com/Bowery/prompt 94b504f42fdd503acc3b3c79ec2b517d90e0de8a"
	"github.com/armon/go-metrics 783273d703149aaeb9897cf58613d5af48861c25"
	"github.com/boltdb/bolt fd01fc79c553a8e99d512a07e8e0c63d4a3ccfc5"
	"github.com/hashicorp/go-immutable-radix 7f3cd4390caab3250a57f30efdb2a65dd7649ecf"
	"github.com/hashicorp/go-msgpack fa3f63826f7c23912c15263591e65d54d080b458"
	"github.com/hashicorp/golang-lru 0fb14efe8c47ae851c0034ed7a448854d3d34cf3"
	"github.com/labstack/gommon 0a22a0df01a7c84944c607e8a6e91cfe421ea7ed"
	"github.com/mattn/go-colorable efa589957cd060542a26d2dd7832fd6a6c6c3ade"
	"github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
	"github.com/mattn/go-sqlite3 b8b158db6fdb72096ff3510373df0f61ea8de773"
	"github.com/mkideal/cli a9c1104566927924fdb041d198f05617492913f9"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/crypto a3beeb748656e13e54256fd2cde19e058f41f60f github.com/golang/crypto"
	"golang.org/x/sys c11f84a56e43e20a78cee75a7c034031ecf57d1f github.com/golang/sys"
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
