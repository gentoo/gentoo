# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A minimalistic console hex editor with vim-like controls"
HOMEPAGE="https://yx7.cc/code/"
SRC_URI="https://yx7.cc/code/hyx/${P}.tar.xz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	# Avoid complaining about not respecting LDFLAGS
	"${FILESDIR}/${PN}-ldflags.patch"
)

src_compile() {
	CC=$(tc-getCC) emake
}

src_install() {
	dobin hyx
}
