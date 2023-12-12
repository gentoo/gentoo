# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: automatic reloading of vim scripts"
HOMEPAGE="https://peterodding.com/code/vim/reload/"
SRC_URI="https://github.com/xolox/vim-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vim-${P}"

LICENSE="MIT"
KEYWORDS="amd64 x86"

RDEPEND=">=app-vim/vim-misc-1.8.5"

VIM_PLUGIN_HELPFILES="${PN}.txt"
