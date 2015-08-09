# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit vim-plugin vcs-snapshot

MY_PN="${PN}.vim"
DESCRIPTION="vim plugin: easily switch between buffers"
HOMEPAGE="https://github.com/fholgado/minibufexpl.vim"
SRC_URI="https://github.com/fholgado/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="bufexplorer.vim"
KEYWORDS="amd64 ~mips ppc x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	# discard unwanted files
	rm .gitignore readme.markdown project.html || die
}
