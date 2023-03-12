# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: easily browse vim buffers"
HOMEPAGE="
  https://www.vim.org/scripts/script.php?script_id=42
  https://github.com/jlanzarotta/bufexplorer"
SRC_URI="https://github.com/jlanzarotta/${PN}/archive/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-v.${PV}"

VIM_PLUGIN_HELPFILES="${PN}.txt"
