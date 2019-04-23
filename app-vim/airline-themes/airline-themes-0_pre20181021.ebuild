# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: a collection of themes for vim-airline"
HOMEPAGE="https://github.com/vim-airline/vim-airline-themes"
SRC_URI="https://dev.gentoo.org/~zlogene/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="MIT"
KEYWORDS="amd64 x86"

DEPEND="app-vim/airline"
RDEPEND="${DEPEND}"
