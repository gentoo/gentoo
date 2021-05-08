# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: extended session management for vim"
HOMEPAGE="http://peterodding.com/code/vim/session/"
SRC_URI="https://github.com/xolox/vim-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND=">=app-vim/vim-misc-1.17.6"

S=${WORKDIR}/vim-${P}
