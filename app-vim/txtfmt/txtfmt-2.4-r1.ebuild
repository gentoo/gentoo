# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: rich text highlighting in vim"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2208"
SRC_URI="https://www.vim.org/scripts/download_script.php?src_id=13856 -> ${P}.tar.gz"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

S=${WORKDIR}
