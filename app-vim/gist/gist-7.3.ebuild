# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

MY_PN=vim-gist
MY_P=${MY_PN}-${PV}

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="vim plugin: interact with gists (gist.github.com)"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=2423 https://github.com/mattn/gist-vim"
SRC_URI="https://github.com/mattn/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh@${GH_TS}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="
	app-vim/webapi
	net-misc/curl
	dev-vcs/git
"

VIM_PLUGIN_HELPFILES="Gist.vim"

S=${WORKDIR}/${MY_P}

src_compile() { :; }
