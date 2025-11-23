# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: NERDTree and tabs in vim"
HOMEPAGE="https://github.com/jistr/vim-nerdtree-tabs"
SRC_URI="https://github.com/jistr/vim-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vim-${P}"

LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"

RDEPEND="app-vim/nerdtree"

VIM_PLUGIN_HELPFILES="${PN}"

DOCS=( CHANGELOG.md README.md )
