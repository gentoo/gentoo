# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin eutils

DESCRIPTION="vim plugin: vimbuddy for the status line"
HOMEPAGE="https://github.com/vim-scripts/vimbuddy.vim"
SRC_URI="https://github.com/vim-scripts/${PN}.vim/archive/${PV}.zip -> ${P}.zip"

LICENSE="public-domain"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"

S="${WORKDIR}/${PN}.vim-${PV}"

VIM_PLUGIN_HELPURI="http://www.vim.org/scripts/script.php?script_id=8"
