# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interpreter and compiler compatible with the ISLisp standard"
HOMEPAGE="https://github.com/sasagawa888/eisl/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sasagawa888/${PN}"
else
	SRC_URI="https://github.com/sasagawa888/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
RESTRICT="test"

DOCS=( README{,-ja}.md documents )

RDEPEND="
	sys-libs/ncurses:=
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
)

src_compile() {
	# bug https://bugs.gentoo.org/939771
	# don't clean and compile in one invocation with --shuffle possible
	local target=""
	for target in clean edlis eisl ; do
		emake CC="$(tc-getCC)" FLAGS="${LDFLAGS}" "${target}"
	done
}

src_test() {
	# Tests run cppcheck (and fail).
	:
}

src_install() {
	dobin edlis eisl

	# Compilation of ISLisp files on installation fails.
	# Do not compile them and mimic "make install".
	insinto "/usr/share/${PN}"
	doins -r library
	doins fast.h ffi.h

	einstalldocs
}
