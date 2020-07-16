# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit golang-base

KEYWORDS="~amd64"
EGO_PN="github.com/xetorthio/${PN}"
DESCRIPTION="Use etcd as a FUSE filesystem"
HOMEPAGE="https://github.com/xetorthio/etcd-fs"
EGIT_COMMIT="395eacbaebccccc5f03ed11dc887ea2f1af300a0"
SRC_URI="https://github.com/xetorthio/etcd-fs/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND="app-arch/unzip
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
