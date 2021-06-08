# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="a REST console for vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=5182 https://github.com/diepm/vim-rest-console"
SRC_URI="https://github.com/diepm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="net-misc/curl"
