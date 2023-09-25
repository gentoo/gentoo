# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: exheres format highlighting"
HOMEPAGE="https://www.exherbolinux.org/"
SRC_URI="https://dev.exherbo.org/distfiles/${PN}/${P}.tar.xz"

LICENSE="vim"
SLOT="0"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="exheres-syntax"
VIM_PLUGIN_MESSAGES="filetype"
