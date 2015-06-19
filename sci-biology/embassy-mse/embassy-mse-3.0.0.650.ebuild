# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-mse/embassy-mse-3.0.0.650.ebuild,v 1.3 2015/03/28 17:59:49 jlec Exp $

EAPI=5

EBO_DESCRIPTION="MSE - Multiple Sequence Screen Editor"
EBO_EXTRA_ECONF="$(use_enable ncurses curses)"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"
IUSE+=" ncurses"

RDEPEND+=" ncurses? ( sys-libs/ncurses )"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )

src_install() {
	autotools-utils_src_install
	insinto /usr/include/emboss/mse
	doins h/*.h
}
