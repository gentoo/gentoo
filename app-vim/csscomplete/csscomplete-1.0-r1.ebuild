# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: CSS 3 omni complete function"
HOMEPAGE="https://github.com/othree/csscomplete.vim"
SRC_URI="https://github.com/othree/${PN}.vim/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.vim-${PV}"

LICENSE="vim.org"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

src_compile() {
	:;
}
