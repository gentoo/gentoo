# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit go-module

DESCRIPTION="\"Go please\" is the official Go language server"
HOMEPAGE="https://github.com/golang/tools/blob/master/gopls/README.md"
SRC_URI="https://github.com/golang/tools/archive/refs/tags/gopls/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/tools/releases/download/gopls%2Fv${PV}/tools-${PN}-v${PV}-deps.tar.xz"
S=${WORKDIR}/tools-gopls-v${PV}/${PN}

LICENSE="BSD"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=">=dev-lang/go-1.26.0"

src_compile() {
	ego build -ldflags "-w -X main.version=${PV}"
}

src_test() {
	rm -v internal/test/marker/testdata/diagnostics/{osarch_suffix,excludedfile}.txt || die
	ego test -work "./..." || die
}

src_install() {
	dobin gopls
	dodoc -r doc README.md
}
