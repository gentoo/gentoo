# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: exheres format highlighting"
HOMEPAGE="https://www.exherbo.org/"
SRC_URI="https://dev.exherbo.org/~ahf/pub/software/releases/${PN}/${P}.tar.bz2"

LICENSE="vim"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="exheres-syntax"
VIM_PLUGIN_MESSAGES="filetype"
