# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="The ABS programing language"
HOMEPAGE="https://github.com/abs-lang/abs https://www.abs-lang.org/"
SRC_URI="https://github.com/abs-lang/abs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT+=" test"

src_prepare() {
	sed -e "s:^var Version = \"dev\"\$:var Version = \"${PV}\":" -i main.go || die
	default
}

src_compile() {
	CGO_ENABLED=0 emake build_simple || die
}

src_install() {
	dobin builds/abs
	dodoc README.md
}
