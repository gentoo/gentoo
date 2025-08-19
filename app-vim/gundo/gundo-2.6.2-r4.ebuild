# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit vim-plugin python-single-r1 vcs-snapshot

DESCRIPTION="vim plugin: visualize your vim undo tree"
HOMEPAGE="https://github.com/sjl/gundo.vim"
SRC_URI="https://github.com/sjl/gundo.vim/archive/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="amd64 x86 ~x64-macos"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	|| (
		app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
		app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
	)
	${PYTHON_DEPS}"

VIM_PLUGIN_HELPFILES="${PN}.txt"

PATCHES=( "${FILESDIR}"/${P}-python3.patch )

src_prepare() {
	rm -r site tests || die
	default
}
