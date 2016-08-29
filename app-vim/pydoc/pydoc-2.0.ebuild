# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: integrates python documentation view and search tool"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=910 https://github.com/fs111/pydoc.vim"
SRC_URI="https://github.com/fs111/${PN}.vim/tarball/${PV} -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-lang/python:*"

src_unpack() {
	default
	mv * "${P}" || die
}
