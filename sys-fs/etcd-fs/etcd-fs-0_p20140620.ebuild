# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KEYWORDS="~amd64"
DESCRIPTION="Use etcd as a FUSE filesystem"
HOMEPAGE="https://github.com/xetorthio/${PN}"
EGIT_COMMIT="395eacbaebccccc5f03ed11dc887ea2f1af300a0"
SRC_URI="${HOMEPAGE}/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
DEPEND="
	>=dev-lang/go-1.3
	dev-db/go-etcd
	dev-libs/go-fuse"
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
