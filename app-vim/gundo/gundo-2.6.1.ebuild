# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: visualize your vim undo tree"
HOMEPAGE="https://sjl.bitbucket.org/gundo.vim/"
SRC_URI="https://github.com/sjl/gundo.vim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND="|| ( app-editors/vim[${PYTHON_USEDEP}] app-editors/gvim[${PYTHON_USEDEP}] )
	${PYTHON_DEPS}"

S=${WORKDIR}/${PN}.vim-${PV}

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm -r .gitignore .hg* package.sh README* site tests || die
}
