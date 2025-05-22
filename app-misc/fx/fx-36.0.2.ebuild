# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION=" Terminal JSON viewer & processor"
HOMEPAGE="https://fx.wtf/ https://github.com/antonmedv/fx"
SRC_URI="https://github.com/antonmedv/fx/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-misc/${PN}/${P}-deps.tar.xz"

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o fx .

	mkdir "${T}/comp"
	./fx --comp bash > "${T}/comp/fx" || die
	./fx --comp zsh > "${T}/comp/_fx" || die
	./fx --comp fish > "${T}/comp/fx.fish" || die
}

src_test() {
	ego test ./...
}

src_install() {
	dobin fx
	dodoc README.md

	dobashcomp "${T}/comp/fx"
	dozshcomp "${T}/comp/_fx"
	dofishcomp "${T}/comp/fx.fish"
}
