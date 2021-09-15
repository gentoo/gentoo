# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

MY_PN="vim-rails"
MY_P=${MY_PN}-${PV}

DESCRIPTION="vim plugin: aids developing Ruby on Rails applications"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=1567 https://github.com/tpope/vim-rails/"
SRC_URI="https://github.com/tpope/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}/${MY_P}
