# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

MY_PN="pf.vim"

DESCRIPTION="vim plugin: pf syntax highlighting for vim"
HOMEPAGE="https://github.com/vim-scripts/pf.vim"
SRC_URI="https://github.com/vim-scripts/pf.vim/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="vim"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${MY_PN}-${PV}"
