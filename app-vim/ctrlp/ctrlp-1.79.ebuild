# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: fuzzy file, buffer, mru, tag, ... finder with regex support"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3736 https://kien.github.com/ctrlp.vim/"
SRC_URI="https://github.com/kien/ctrlp.vim/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm readme.md || die
}
