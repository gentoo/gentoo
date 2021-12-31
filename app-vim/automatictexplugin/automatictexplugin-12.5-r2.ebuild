# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 vim-plugin

MY_P="AutomaticTexPlugin_${PV}"
DESCRIPTION="vim plugin: a comprehensive plugin for editing LaTeX files"
HOMEPAGE="http://atp-vim.sourceforge.net/"
SRC_URI="mirror://sourceforge/atp-vim/releases/${MY_P}.tar.gz"
LICENSE="GPL-3"
KEYWORDS="amd64 x86"

S=${WORKDIR}

VIM_PLUGIN_HELPFILES="automatic-tex-plugin.txt"

RDEPEND="
	|| (
		app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
		app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
	)
	!app-vim/vim-latex
	app-vim/align
	app-text/wdiff
	$(python_gen_cond_dep '
		dev-python/psutil[${PYTHON_MULTI_USEDEP}]
	')
	dev-tex/latexmk
	dev-tex/detex
	virtual/tex-base
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	python_fix_shebang .
}
