# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: a modern vim plugin for editing LaTeX files"
HOMEPAGE="https://github.com/lervag/vimtex"
SRC_URI="https://github.com/lervag/vimtex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~riscv ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="
	!app-vim/vim-latex
	!app-vim/automatictexplugin
"

src_install() {
	vim-plugin_src_install lua
}
