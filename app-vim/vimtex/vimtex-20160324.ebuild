# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit vim-plugin

DESCRIPTION="vim plugin: a modern vim plugin for editing LaTeX files"
HOMEPAGE="https://github.com/lervag/vimtex"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

RDEPEND="!app-vim/vim-latex
	virtual/latex-base
	dev-tex/latexmk"

src_prepare() {
	rm -rf *.md test || die
}
