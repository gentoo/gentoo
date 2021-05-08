# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin vcs-snapshot

MY_PN="Screen-vim---gnu-screentmux"
DESCRIPTION="vim plugin: simulate a split shell with screen or tmux"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2711"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"
LICENSE="public-domain"
KEYWORDS="amd64 ~arm64 x86"

VIM_PLUGIN_HELPFILES="screen.txt"

RDEPEND="|| ( app-misc/screen app-misc/tmux )"
