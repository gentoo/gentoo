# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gundo/gundo-2.5.0.ebuild,v 1.4 2015/04/08 07:30:35 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit vim-plugin python-single-r1

DESCRIPTION="vim plugin: visualize your Vim undo tree"
HOMEPAGE="http://sjl.bitbucket.org/gundo.vim/"
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
