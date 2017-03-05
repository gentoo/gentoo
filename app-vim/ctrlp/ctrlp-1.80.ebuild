# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: fuzzy file, buffer, mru, tag, ... finder with regex support"
HOMEPAGE="https://github.com/ctrlpvim/ctrlp.vim"
SRC_URI="https://github.com/${PN}vim/${PN}.vim/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}.vim-${PV}"

VIM_PLUGIN_HELPFILES="${PN}.txt"
