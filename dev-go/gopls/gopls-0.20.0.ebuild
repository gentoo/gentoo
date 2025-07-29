# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="\"Go please\" is the official Go language server"
HOMEPAGE="https://github.com/golang/tools/blob/master/gopls/README.md"
SRC_URI="
	https://github.com/golang/tools/archive/refs/tags/gopls/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/douglarek/gentoo-deps/releases/download/${P}/${P}-vendor.tar.xz -> ${P}-deps.tar.xz
"
S=${WORKDIR}/tools-gopls-v${PV}/${PN}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=">=dev-lang/go-1.24.2"
# TODO: fix test failure with deps tarball
RESTRICT+=" test"

src_compile() {
	ego build
}

src_test() {
	ego test -work "./..." || die
}

src_install() {
	dobin gopls
	dodoc -r doc README.md
}
