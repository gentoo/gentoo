# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# TODO: supposedly supports python3... but that conflicts with pygtk
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: a color tool for vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=3597 https://github.com/Rykka/colorv.vim/"
LICENSE="MIT"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		|| (
			app-editors/vim[python,${PYTHON_SINGLE_USEDEP}]
			(
				app-editors/gvim[python,${PYTHON_SINGLE_USEDEP}]
				dev-python/pygtk:2[${PYTHON_MULTI_USEDEP}]
			)
		)
	')"

src_prepare() {
	eapply_user

	# fix shebangs in Python files (note: one of them is python3...)
	sed -i -e "1s:python[23]:${EPYTHON}:" autoload/colorv/*.py || die
	# use python colorpicker instead of C-based picker
	rm autoload/colorv/{colorpicker.c,Makefile} || die
}
