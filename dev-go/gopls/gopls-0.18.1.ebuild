# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

ARCHIVE_URI="https://github.com/golang/tools/archive/refs/tags/gopls/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="\"Go please\" is the official Go language server"
HOMEPAGE="https://github.com/golang/tools/blob/master/gopls/README.md"
SLOT="0"
LICENSE="BSD"
BDEPEND=">=dev-lang/go-1.23.4"
SRC_URI="
	${ARCHIVE_URI}
	https://github.com/douglarek/gentoo-deps/releases/download/${P}/${P}-vendor.tar.xz -> ${P}-deps.tar.xz
"
# TODO: fix test failure with deps tarball
RESTRICT+=" test"

S=${WORKDIR}/tools-gopls-v${PV}/${PN}

src_compile() {
	ego build
}

src_test() {
	go test -work "./..." || die
}

src_install() {
	dobin gopls
	dodoc -r doc README.md
}
