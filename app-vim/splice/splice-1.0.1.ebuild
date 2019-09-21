# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: resolve conflicts during three-way merges"
HOMEPAGE="https://bitbucket.org/sjl/splice.vim/ https://www.vim.org/scripts/script.php?script_id=4026"

LICENSE="MIT"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	|| (
		app-editors/vim[python]
		app-editors/gvim[python]
	)"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm LICENSE.markdown || die
}

src_install() {
	vim-plugin_src_install
	python_optimize "${ED}"/usr/share/vim/vimfiles/autoload/splicelib
}
