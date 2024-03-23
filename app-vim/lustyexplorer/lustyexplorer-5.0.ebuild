# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

MY_PN="lusty-explorer"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="vim plugin: dynamic filesystem and buffer explorer"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1890"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=26146 -> ${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="bufexplorer.vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="lusty-explorer.txt"

BDEPEND="app-arch/unzip"
RDEPEND="|| (
	app-editors/vim[ruby]
	app-editors/gvim[ruby]
)"

src_prepare() {
	default

	# There's good documentation included with the script, but it's not
	# in a helpfile. Since there's rather too much information to include
	# in a VIM_PLUGIN_HELPTEXT, we'll sed ourselves a help doc.
	mkdir "${S}"/doc || die
	sed -e '0,/"$/d' -e '/" GetLatest.\+$/,9999d' -e 's/^" \?//' \
		-e "s/\(Name Of File: \)\([^.]\+\)\.vim/\1*\2.txt*/" \
		plugin/lusty-explorer.vim > doc/lusty-explorer.txt
}
