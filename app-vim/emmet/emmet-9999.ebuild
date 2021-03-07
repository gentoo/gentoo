# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin git-r3

DESCRIPTION="vim plugin: HTML and CSS hi-speed coding"
HOMEPAGE="https://mattn.github.io/emmet-vim https://emmet.io"
LICENSE="BSD"
EGIT_REPO_URI="https://github.com/mattn/emmet-vim.git"

VIM_PLUGIN_HELPFILES="${PN}.txt"
