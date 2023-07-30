# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interpreter and compiler compatible with the ISLisp standard"
HOMEPAGE="https://github.com/sasagawa888/eisl/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sasagawa888/${PN}.git"
else
	SRC_URI="https://github.com/sasagawa888/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
RESTRICT="test"  # Tests run cppcheck (and fail)

DOCS=( README{,-ja}.md documents )

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-2.85-Makefile.patch )

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
