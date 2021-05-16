# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="An interpreter for the classic dialect of the programming language BASIC"
HOMEPAGE="http://www.moria.de/~michael/bas/"
SRC_URI="http://www.moria.de/~michael/bas/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lr0"

RDEPEND="
	sys-libs/ncurses
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=( "${FILESDIR}"/${PN}-2.1-makefile.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoconf
}

src_configure() {
	tc-export AR
	econf $(use_enable lr0)
}

src_install() {
	default

	docinto pdf
	dodoc bas.pdf
}
