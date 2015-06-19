# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/automatictexplugin/automatictexplugin-12.5-r1.ebuild,v 1.3 2015/02/09 00:30:54 radhermit Exp $

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

RDEPEND="|| ( app-editors/vim[python,${PYTHON_USEDEP}] app-editors/gvim[python,${PYTHON_USEDEP}] )
	!app-vim/vim-latex
	app-vim/align
	app-text/wdiff
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-tex/latexmk
	dev-tex/detex
	virtual/tex-base
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_prepare() {
	python_fix_shebang .
}
