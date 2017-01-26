# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: NERDTree and tabs in vim"
HOMEPAGE="https://github.com/jistr/vim-nerdtree-tabs"
SRC_URI="https://github.com/jistr/vim-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"

RDEPEND="app-vim/nerdtree"

S="${WORKDIR}/vim-${P}"

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	default
	rm LICENSE README.md || die
}
