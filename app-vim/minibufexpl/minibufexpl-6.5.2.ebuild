# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/minibufexpl/minibufexpl-6.5.2.ebuild,v 1.4 2013/12/24 12:56:55 ago Exp $

EAPI=5

inherit vim-plugin

MY_PN="${PN}.vim"
DESCRIPTION="vim plugin: easily switch between buffers"
HOMEPAGE="https://github.com/fholgado/minibufexpl.vim"
SRC_URI="https://github.com/fholgado/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="bufexplorer.vim"
KEYWORDS="amd64 ~mips ppc x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	# discard unwanted files
	rm .gitignore README.md || die
}
