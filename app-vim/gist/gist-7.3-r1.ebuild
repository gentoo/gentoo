# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

MY_PN="gist-vim"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="vim plugin: interact with gists (gist.github.com)"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2423
	https://github.com/mattn/vim-gist"
SRC_URI="https://github.com/mattn/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="
	app-vim/webapi
	net-misc/curl
	dev-vcs/git
"

VIM_PLUGIN_HELPFILES="Gist.vim"

src_compile() { :; }
