# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: rich text highlighting in vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2208"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=13856 -> ${P}.tar.gz"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}

src_prepare() {
	default
	rm indent_patch.txt || die
}
