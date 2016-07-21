# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: buffer/file/command/tag/etc explorer with fuzzy matching"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1984"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=13961 -> ${P}.zip"
LICENSE="MIT"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="fuf"

DEPEND="app-arch/unzip"
RDEPEND="app-vim/l9"

S="${WORKDIR}"
