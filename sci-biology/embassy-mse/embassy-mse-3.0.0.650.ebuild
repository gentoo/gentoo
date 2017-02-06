# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBO_DESCRIPTION="MSE - Multiple Sequence Screen Editor"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="amd64 x86 ~x86-linux ~ppc-macos"
IUSE+=" ncurses"

RDEPEND+=" ncurses? ( sys-libs/ncurses )"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )

src_configure() {
	EBO_EXTRA_ECONF="$(use_enable ncurses curses)"
	emboss-r1_src_configure
}

src_install() {
	autotools-utils_src_install
	insinto /usr/include/emboss/mse
	doins h/*.h
}
