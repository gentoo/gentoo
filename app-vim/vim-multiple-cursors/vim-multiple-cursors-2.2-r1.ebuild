# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: Sublime Text's awesome multiple selection feature for Vim"
HOMEPAGE="https://github.com/terryma/vim-multiple-cursors"
SRC_URI="https://github.com/terryma/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

src_install() {
	default
	vim-plugin_src_install
	rm -r \
		"${ED}"/usr/share/vim/vimfiles/spec \
		"${ED}"/usr/share/vim/vimfiles/assets \
		|| die "rm failed"
}
