# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: NERDTree and tabs in vim"
HOMEPAGE="https://github.com/jistr"
SRC_URI="https://github.com/jistr/vim-${PN}/archive/v${PV}.zip -> ${P}.zip"
LICENSE="Apache-1.1"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="app-vim/nerdtree"

S="${WORKDIR}/vim-${P}"
