# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: emulates a two-pane text outliner"
HOMEPAGE="https://vim-voom.github.com/ https://www.vim.org/scripts/script.php?script_id=2657"

LICENSE="CC0-1.0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="${PYTHON_DEPS}
	|| (
		app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
		app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
	)"
