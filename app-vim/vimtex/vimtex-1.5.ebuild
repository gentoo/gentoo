# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: a modern vim plugin for editing LaTeX files"
HOMEPAGE="https://github.com/lervag/vimtex"
SRC_URI="https://github.com/lervag/vimtex/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT"

VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="
	!app-vim/vim-latex
	!app-vim/automatictexplugin"

src_prepare() {
	default

	# remove unwanted dirs
	rm -r media test || die
}
