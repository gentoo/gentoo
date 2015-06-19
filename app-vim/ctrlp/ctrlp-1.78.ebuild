# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/ctrlp/ctrlp-1.78.ebuild,v 1.1 2012/09/09 11:21:23 radhermit Exp $

EAPI=4

inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: fuzzy file, buffer, mru, tag, ... finder with regex support"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3736 http://kien.github.com/ctrlp.vim/"
SRC_URI="https://github.com/kien/ctrlp.vim/tarball/${PV} -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm .gitignore readme.md || die
}
