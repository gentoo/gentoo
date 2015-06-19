# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/dirdiff/dirdiff-1.1.4.ebuild,v 1.3 2013/11/30 12:51:25 johu Exp $

EAPI="4"

inherit vim-plugin

MY_PN="DirDiff.vim"
DESCRIPTION="vim plugin: diff and merge two directories recursively"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=102"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 x86"
IUSE=""

VIM_PLUGIN_HELPFILES="DirDiff.txt"

RDEPEND="sys-apps/diffutils"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	# There's good documentation included with the script, but it's not
	# in a helpfile. Since there's rather too much information to include
	# in a VIM_PLUGIN_HELPTEXT, we'll sed ourselves a help doc.
	mkdir "${S}"/doc
	sed -e '0,/" -\*- vim -\*-$/d' -e '/"  0.7  Initial Release$/,9999d' -e 's/^" \?//' \
		-e 's/\(FILE: \)".\+\.vim"/\1*DirDiff.txt*/' \
		plugin/DirDiff.vim \
		> doc/DirDiff.txt

	rm -f README
}
