# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rqlite/rqlite"
EGO_VENDOR=(
	"github.com/Bowery/prompt 753711fea478fa77bb2c83f6ec244b814d4a8bad"
	"github.com/armon/go-metrics 0a12dc6f6b9da6da644031a1b9b5a85478c5ee27"
	"github.com/boltdb/bolt fa5367d20c994db73282594be0146ab221657943"
	"github.com/hashicorp/go-immutable-radix 8aac2701530899b64bdea735a1de8da899815220"
	"github.com/hashicorp/go-msgpack fa3f63826f7c23912c15263591e65d54d080b458"
	"github.com/hashicorp/golang-lru 0a025b7e63adc15a622f29b0b2c4c3848243bbf6"
	"github.com/hashicorp/raft 3b4d64b29e422f04808b905005eb5a38bf9150e8"
	"github.com/hashicorp/raft-boltdb df631556b57507bd5d0ed4f87468fd93ab025bef"
	"github.com/labstack/gommon 779b8a8b9850a97acba6a3fe20feb628c39e17c1"
	"github.com/mattn/go-colorable ad5389df28cdac544c99bd7b9161a0b5b6ca9d1b"
	"github.com/mattn/go-isatty fc9e8d8ef48496124e79ae0df75490096eccf6fe"
	"github.com/mattn/go-sqlite3 05548ff55570cdb9ac72ff4a25a3b5e77a6fb7e5"
	"github.com/mkideal/cli a9c1104566927924fdb041d198f05617492913f9"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/net 859d1a86bb617c0c20d154590c3c5d3fcb670b07 github.com/golang/net"
	"golang.org/x/sys 062cd7e4e68206d8bab9b18396626e855c992658 github.com/golang/sys"
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
