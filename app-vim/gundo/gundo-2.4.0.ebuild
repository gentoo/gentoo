# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/gundo/gundo-2.4.0.ebuild,v 1.1 2012/08/03 09:59:40 radhermit Exp $

EAPI=4

inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: visualize your Vim undo tree"
HOMEPAGE="http://sjl.bitbucket.org/gundo.vim/"
SRC_URI="https://github.com/sjl/gundo.vim/tarball/v${PV} -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( app-editors/vim[python] app-editors/gvim[python] )
	>=dev-lang/python-2.4"

VIM_PLUGIN_HELPFILES="gundo.txt"

src_prepare() {
	rm -r .gitignore .hg* package.sh README* site tests || die
}
