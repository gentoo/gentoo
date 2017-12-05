# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base

KEYWORDS="~amd64"
EGO_PN="github.com/xetorthio/${PN}"
DESCRIPTION="Use etcd as a FUSE filesystem"
HOMEPAGE="https://${EGO_PN}"
EGIT_COMMIT="1eeace3bc20b15e4347c631a1cf7b45f3852518a"
SRC_URI="${HOMEPAGE}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="
	dev-db/go-etcd:=
	dev-libs/go-fuse:="
RDEPEND=""
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_compile() {
	CGO_CFLAGS=${CFLAGS} GOPATH=${S} \
		go build \
		-x -ldflags="-v -linkmode=external -extldflags '${LDFLAGS}'" \
		etcdfs.go || die
}

src_install() {
	dobin etcdfs
	dodoc README.md
}
