# Copyright 1999-2023 Gentoo Authors
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

DOCS=( README{,-ja}.md documents )

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.67-Makefile.patch
	"${FILESDIR}"/${PN}-2.65-implicit.patch
)

src_compile() {
	emake CC="$(tc-getCC)" clean edlis eisl
}

src_install() {
	exeinto /usr/bin
	doexe edlis eisl

	# Compilation of ISLisp files on installation fails.
	# Do not compile them and mimic "make install".
	insinto /usr/share/${PN}
	doins -r library
	doins fast.h ffi.h

	einstalldocs
}
