# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rqlite/rqlite"
EGO_VENDOR=(
	"github.com/Bowery/prompt eb8f7a6a197ce971ed0e9d4a739c628381d5f124"
	"github.com/armon/go-metrics 023a4bbe4bb9bfb23ee7e1afc8d0abad217641f3"
	"github.com/boltdb/bolt 2f1ce7a837dcb8da3ec595b1dac9d0632f0f99e8"
	"github.com/hashicorp/go-immutable-radix 8aac2701530899b64bdea735a1de8da899815220"
	"github.com/hashicorp/go-msgpack fa3f63826f7c23912c15263591e65d54d080b458"
	"github.com/hashicorp/golang-lru 0a025b7e63adc15a622f29b0b2c4c3848243bbf6"
	"github.com/hashicorp/raft ac704075e75b8626023224c76c56be4d6958a5dc"
	"github.com/hashicorp/raft-boltdb df631556b57507bd5d0ed4f87468fd93ab025bef"
	"github.com/labstack/gommon 779b8a8b9850a97acba6a3fe20feb628c39e17c1"
	"github.com/mattn/go-colorable 6c0fd4aa6ec5818d5e3ea9e03ae436972a6c5a9a"
	"github.com/mattn/go-isatty fc9e8d8ef48496124e79ae0df75490096eccf6fe"
	"github.com/mattn/go-sqlite3 6654e412c3c7eabb310d920cf73a2102dbf8c632"
	"github.com/mkideal/cli a9c1104566927924fdb041d198f05617492913f9"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/net 1c05540f6879653db88113bc4a2b70aec4bd491f github.com/golang/net"
	"golang.org/x/sys b0e0dd72976dc482b6cb37c5640440f876ac1907 github.com/golang/sys"
)

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Replicated SQLite using the Raft consensus protocol"

HOMEPAGE="https://${EGO_PN} http://www.philipotoole.com/tag/rqlite/"
LICENSE="MIT"
SLOT="0"
IUSE=""
EGIT_REPO_URI="https://${EGO_PN}.git"
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

src_compile() {
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} ${EGO_PN}/cmd/... || die
}

src_install() {
	dobin bin/${PN}{,d}
	dodoc "${S}/src/${EGO_PN}/"*.md
}
