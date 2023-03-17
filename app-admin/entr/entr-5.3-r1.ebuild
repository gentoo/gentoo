# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Run arbitrary commands when files change"
HOMEPAGE="
	https://eradman.com/entrproject/
	https://github.com/eradman/entr
"
SRC_URI="https://eradman.com/entrproject/code/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-editors/vim
		app-misc/tmux
		dev-vcs/git
		sys-apps/file
	)
"

PATCHES=(
	"${FILESDIR}/${P}-no-which.patch"
)

src_configure() {
	tc-export CC
	export PREFIX="${EPREFIX}/usr"
	export SHELL="${BROOT}/bin/bash"
	export TMUX_TMPDIR="${T}"

	edo ./configure
}
