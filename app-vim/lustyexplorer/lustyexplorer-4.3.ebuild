# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: dynamic filesystem and buffer explorer"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1890"
LICENSE="bufexplorer.vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="lusty-explorer.txt"

RDEPEND="|| ( app-editors/vim[ruby] app-editors/gvim[ruby] )"

src_prepare() {
	# There's good documentation included with the script, but it's not
	# in a helpfile. Since there's rather too much information to include
	# in a VIM_PLUGIN_HELPTEXT, we'll sed ourselves a help doc.
	mkdir "${S}"/doc
	sed -e '0,/"$/d' -e '/" GetLatest.\+$/,9999d' -e 's/^" \?//' \
		-e "s/\(Name Of File: \)\([^.]\+\)\.vim/\1*\2.txt*/" \
		plugin/lusty-explorer.vim > doc/lusty-explorer.txt
}
