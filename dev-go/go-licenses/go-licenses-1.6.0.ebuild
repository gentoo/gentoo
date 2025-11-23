# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion edo go-module

DESCRIPTION="Reports on the licenses used by a Go package and its dependencies"
HOMEPAGE="https://github.com/google/go-licenses"
SRC_URI="https://github.com/google/go-licenses/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" BSD-2 BSD MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"
PROPERTIES="test_network"

src_compile() {
	ego build

	local shell
	for shell in bash fish zsh ; do
		edo ./go-licenses completion ${shell} > go-licenses.${shell}
	done
}

src_test() {
	ego test ./...
}

src_install() {
	einstalldocs

	dobin ${PN}

	newbashcomp ${PN}.bash ${PN}
	newzshcomp ${PN}.zsh _${PN}
	dofishcomp ${PN}.fish
}
