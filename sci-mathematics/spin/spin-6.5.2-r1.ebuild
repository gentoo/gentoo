# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

MY_PN="${PN^}"
MY_PV="version-${PV}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="An efficient logic-model checker for the verification of multi-threaded code"
HOMEPAGE="https://spinroot.com/ https://github.com/nimble-code/Spin"
SRC_URI="https://github.com/nimble-code/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="doc examples graphviz tk"

RDEPEND="sys-devel/gcc
	tk? (
		dev-lang/tk
		graphviz? ( media-gfx/graphviz )
	)"
BDEPEND="app-alternatives/yacc"

PATCHES=(
	"${FILESDIR}"/${PN}-6.5.2-makefile.patch
	"${FILESDIR}"/${PN}-6.5.2-nesting_limit.patch
)

S="${WORKDIR}"/${MY_P}/Src

src_compile() {
	tc-export CC
	default
}

src_install() {
	dobin ${PN}
	dodoc ../Man/README.md
	doman ../Man/${PN}.1

	use doc && dodoc ../Doc/*
	if use examples; then
		docinto examples
		dodoc -r ../Examples/*
	fi

	if use tk; then
		newbin ../optional_gui/i${PN}.tcl i${PN}
		make_desktop_entry ispin
	fi
}
