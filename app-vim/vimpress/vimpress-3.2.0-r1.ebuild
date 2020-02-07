# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: manage wordpress blogs from vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3510"
LICENSE="vim"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	|| (
		app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
		app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
	)
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/markdown[${PYTHON_MULTI_USEDEP}]
	')"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

VIM_PLUGIN_HELPFILES="${PN}.txt"
