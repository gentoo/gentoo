# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/cctree/cctree-1.60.ebuild,v 1.2 2012/12/22 08:16:16 ulm Exp $

EAPI=4

inherit vim-plugin

MY_PN="CCTree"
DESCRIPTION="vim plugin: Cscope based source-code browser and code flow analysis tool"
HOMEPAGE="http://sites.google.com/site/vimcctree/"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="bufexplorer.vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="cctree.txt"

RDEPEND="dev-util/cscope"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	# There's good documentation included with the script, but it's not
	# in a helpfile. Since there's rather too much information to include
	# in a VIM_PLUGIN_HELPTEXT, we'll sed ourselves a help doc.
	mkdir doc
	sed -e '/" Name Of File/,/".\+Community/!d' -e 's/^" \?//' \
		-e 's/\(Name Of File: \)\([^.]\+\)\.vim/\1*\L\2.txt*/' \
		ftplugin/cctree.vim > doc/cctree.txt

	rm README
}
