# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: resolve conflicts during three-way merges"
HOMEPAGE="https://docs.stevelosh.com/splice.vim/ https://github.com/sjl/splice.vim https://www.vim.org/scripts/script.php?script_id=4026"
SRC_URI="https://github.com/sjl/splice.vim/archive/v${PV}.tar.gz -> ${P}-github.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	|| (
		app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
		app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
	)"

S="${WORKDIR}/splice.vim-${PV}"
VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	default
	rm .[a-z]* Makefile LICENSE.markdown package.sh || die
	rm -r site || die
}

src_install() {
	vim-plugin_src_install
	python_optimize "${ED}"/usr/share/vim/vimfiles/autoload/splicelib
}
