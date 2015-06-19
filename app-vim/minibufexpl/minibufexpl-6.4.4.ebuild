# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/minibufexpl/minibufexpl-6.4.4.ebuild,v 1.5 2012/12/22 08:18:38 ulm Exp $

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
