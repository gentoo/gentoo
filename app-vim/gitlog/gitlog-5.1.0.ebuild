# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vim-plugin

DESCRIPTION="vim plugin: git log and diff plugin for vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=4294 https://github.com/PAntoine/vimgitlog/"
SRC_URI="https://github.com/PAntoine/vimgitlog/archive/version_${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Artistic"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}/vim${PN}-version_${PV}
