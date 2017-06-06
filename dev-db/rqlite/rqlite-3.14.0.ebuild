# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/rqlite/rqlite"
EGO_VENDOR=(
	"github.com/Bowery/prompt 0f1139e9a1c74b57ccce6bdb3cd2f7cd04dd3449"
	"github.com/armon/go-metrics f036747b9d0e8590f175a5d654a2194a7d9df4b5"
	"github.com/boltdb/bolt e9cf4fae01b5a8ff89d0ec6b32f0d9c9f79aefdd"
	"github.com/hashicorp/go-msgpack fa3f63826f7c23912c15263591e65d54d080b458"
	"github.com/hashicorp/raft 37d2320db05ca622195063977ff5d4fbe0cd8ed8"
	"github.com/hashicorp/raft-boltdb df631556b57507bd5d0ed4f87468fd93ab025bef"
	"github.com/labstack/gommon 1121fd3e243c202482226a7afe4dcd07ffc4139a"
	"github.com/mattn/go-colorable ded68f7a9561c023e790de24279db7ebf473ea80"
	"github.com/mattn/go-isatty fc9e8d8ef48496124e79ae0df75490096eccf6fe"
	"github.com/mattn/go-sqlite3 83772a7051f5e30d8e59746a9e43dfa706b72f3b"
	"github.com/mkideal/cli a9c1104566927924fdb041d198f05617492913f9"
	"github.com/mkideal/pkg 3e188c9e7ecc83d0fe7040a9161ce3c67885470d"
	"golang.org/x/net 59a0b19b5533c7977ddeb86b017bf507ed407b12 github.com/golang/net"
	"golang.org/x/sys b90f89a1e7a9c1f6b918820b3daa7f08488c8594 github.com/golang/sys"
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
