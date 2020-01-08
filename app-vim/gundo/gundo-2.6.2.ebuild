# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit vim-plugin python-single-r1 vcs-snapshot

DESCRIPTION="vim plugin: visualize your vim undo tree"
HOMEPAGE="https://sjl.bitbucket.io/gundo.vim/"
SRC_URI="https://bitbucket.org/sjl/gundo.vim/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="amd64 x86 ~x64-macos"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	|| (
		app-editors/vim[python,${PYTHON_USEDEP}]
		app-editors/gvim[python,${PYTHON_USEDEP}]
	)
	${PYTHON_DEPS}"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm -r .gitignore .hg* package.sh README* site tests || die
	default
}
