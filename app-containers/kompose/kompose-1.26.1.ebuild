# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
GIT_COMMIT=a9d05d50

DESCRIPTION="Tool to move from docker-compose to Kubernetes"
HOMEPAGE="https://github.com/kubernetes/kompose https://kompose.io"
SRC_URI="https://github.com/kubernetes/kompose/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hardened"

RESTRICT+=" test"

src_prepare() {
	default
	sed -i -e 's/-w -s//' Makefile || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	emake \
		GITCOMMIT=${GIT_COMMIT} \
		bin
}

src_install() {
	dobin ${PN}
	dodoc -r docs examples {README,RELEASE,CHANGELOG,CONTRIBUTING}.md
}
