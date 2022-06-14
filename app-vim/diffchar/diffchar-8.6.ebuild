# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin vcs-snapshot

GIT_HASH="c889cc133e8c6a1ba9ff089a6b9a6b94bd345cb4"

DESCRIPTION="vim plugin: highlight the exact differences, based on characters and words"
HOMEPAGE="https://github.com/rickhowe/diffchar.vim https://www.vim.org/scripts/script.php?script_id=4932"
SRC_URI="https://github.com/rickhowe/diffchar.vim/archive/${GIT_HASH}.tar.gz -> ${P}.tar.gz"
LICENSE="vim.org"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"
