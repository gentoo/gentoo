# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="An assembler for x86 and x86_64 instruction sets"
HOMEPAGE="http://yasm.tortall.net/"
SRC_URI="http://www.tortall.net/projects/yasm/releases/${P}.tar.gz"

LICENSE="BSD-2 BSD || ( Artistic GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="-* amd64 ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="
	nls? ( virtual/libintl )
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_configure() {
	local myconf=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		CCLD_FOR_BUILD="$(tc-getBUILD_CC)"
		--disable-python
		--disable-python-bindings
		$(use_enable nls)
	)
	XMLTO=: econf "${myconf[@]}"
}

src_test() {
	# https://bugs.gentoo.org/718870
	emake -j1 check
}
