# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interpreter and compiler compatible with the ISLisp standard"
HOMEPAGE="https://github.com/sasagawa888/eisl/"
SRC_URI="https://github.com/sasagawa888/eisl/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"  # Tests run cppcheck (and fail)

DOCS=( README-ja.md README.md documents )

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-compat-no-cdefs.patch
)

src_compile() {
	emake CC="$(tc-getCC)" clean all
}

src_install() {
	dobin edlis eisl

	einstalldocs
}
