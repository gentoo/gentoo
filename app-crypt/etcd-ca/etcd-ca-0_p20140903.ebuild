# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KEYWORDS="~amd64"
DESCRIPTION="A simple certificate manager written in Go. Easy to use with limited capability"
HOMEPAGE="https://github.com/coreos/etcd-ca"
EGIT_COMMIT="812f3626796be16d9db052720ce9c54f5a40bb26"
SRC_URI="${HOMEPAGE}/archive/${EGIT_COMMIT}.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc"
DEPEND=">=dev-lang/go-1.2"
RDEPEND=""
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_prepare() {
	sed -e "s:^\(go install\)\(.*\)$:\\1 -x -ldflags=\"-v -linkmode=external -extldflags '${LDFLAGS}'\" \\2:" \
		-i build || die
}

src_compile() {
	CGO_CFLAGS="${CFLAGS}" ./build || die
}

# go tool: no such tool "cover"; to install:
#    go get code.google.com/p/go.tools/cmd/cover
#src_test() {
#	./test || die
#}

src_install() {
	dobin "${S}"/bin/${PN}
	dodoc README.md
	use doc && dodoc -r Documentation
}
