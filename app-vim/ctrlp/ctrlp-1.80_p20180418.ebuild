# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin vcs-snapshot

# Commit Date: 18 Apr 2018
COMMIT="4b9e7cac612902a25498cca49f13475fe1a821a4"

DESCRIPTION="vim plugin: fuzzy file, buffer, mru, tag, ... finder with regex support"
HOMEPAGE="https://github.com/ctrlpvim/ctrlp.vim"
SRC_URI="https://github.com/${PN}vim/${PN}.vim/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

DOCS=( readme.md )
