# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
VIM_PLUGIN_VIM_VERSION="7.2"

inherit vim-plugin

DESCRIPTION="vim plugin: rich text highlighting in vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2208"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=13856 -> ${P}.tar.gz"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="txtfmt.txt"

S=${WORKDIR}

src_prepare() {
	rm indent_patch.txt
}
