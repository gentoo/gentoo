# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A minimalistic console hex editor with vim-like controls"
HOMEPAGE="https://yx7.cc/code/"
SRC_URI="https://yx7.cc/code/hyx/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

src_compile() {
	CC=$(tc-getCC) emake
}

src_install() {
	dobin hyx
}
