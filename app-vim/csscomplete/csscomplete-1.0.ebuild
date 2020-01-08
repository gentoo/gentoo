# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: CSS 3 omni complete function"
HOMEPAGE="https://github.com/othree/csscomplete.vim"
SRC_URI="https://github.com/othree/${PN}.vim/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="vim.org"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}.vim-${PV}"

src_prepare() {
	default
	rm -v config.mk || die
}

src_compile() {
	:;
}
