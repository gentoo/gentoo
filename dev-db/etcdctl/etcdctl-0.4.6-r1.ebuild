# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
KEYWORDS="~amd64"
DESCRIPTION="A simple command line client for etcd"
HOMEPAGE="https://github.com/coreos/etcdctl/"
SRC_URI="https://github.com/coreos/etcdctl/archive/v${PV}.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="examples"

DEPEND=">=dev-lang/go-1.2:="
RDEPEND=""

src_prepare() {
	sed -e "s:^\(go install\)\(.*\)$:\\1 -x -ldflags=\"-v -linkmode=external -extldflags '${LDFLAGS}'\" \\2:" \
		-i build || die
}

src_compile() {
	CGO_CFLAGS="${CFLAGS}" ./build || die
}

src_test() {
	./test || die
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
	use examples && dodoc -r examples
}
