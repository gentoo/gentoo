# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vim-plugin

DESCRIPTION="vim plugin: Colour parentheses to differentiate nest levels"
HOMEPAGE="https://github.com/kien/rainbow_parentheses.vim"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.zip"
S="${WORKDIR}/${PN}.vim-master"

LICENSE="vim"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

DOCS=( readme.md )
