# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/jlanzarotta/bufexplorer.git"
	inherit git-r3
else
	SRC_URI="https://github.com/jlanzarotta/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="vim plugin: easily browse vim buffers"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=42 https://github.com/jlanzarotta/bufexplorer"
LICENSE="BSD"

VIM_PLUGIN_HELPFILES="${PN}.txt"
