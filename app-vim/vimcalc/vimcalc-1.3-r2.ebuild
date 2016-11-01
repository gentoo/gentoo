# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit python-single-r1 vim-plugin

DESCRIPTION="vim plugin: provides an interactive calculator inside vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3329"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=15317 -> ${P}.zip"
LICENSE="vim"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="vimcalc"

DEPEND="
	app-arch/unzip
	${PYTHON_DEPS}"

RDEPEND="
	|| ( app-editors/vim[python,${PYTHON_USEDEP}] app-editors/gvim[python,${PYTHON_USEDEP}] )
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	# Remove .DS_Store files that should not be installed
	find -type f -name '.DS*' -delete || die
}

src_test() {
	cd plugin || die
	"${PYTHON}" tests.py || die "Tests failed"
}

src_install() {
	rm plugin/tests.py || die
	vim-plugin_src_install
}
