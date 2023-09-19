# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A simple, modern and secure encryption tool (and Go library)"
HOMEPAGE="https://github.com/FiloSottile/age"
SRC_URI="https://github.com/FiloSottile/age/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

S="${WORKDIR}/age-${PV}"

LICENSE="BSD"
#RESTRICT+=" test"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="dev-go/gox"

src_compile() {
	go build -ldflags "-X main.Version=${PV}" -o . filippo.io/age/cmd/... || die
}

src_test() {
	go test -race filippo.io/age/cmd/... || die
}

src_install() {
	dobin age age-keygen
	doman doc/age.1 doc/age-keygen.1
	dodoc README.md
}
