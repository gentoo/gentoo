# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: CSS 3 omni complete function"
HOMEPAGE="https://github.com/othree/csscomplete.vim"
SRC_URI="https://github.com/othree/${PN}.vim/archive/${PV}.zip -> ${P}.zip"
LICENSE="vim.org"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}.vim-${PV}"

src_prepare() {
	default
	rm -v config.mk || die
}

src_compile() {
	:;
}
