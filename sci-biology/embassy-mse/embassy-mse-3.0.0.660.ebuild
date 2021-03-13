# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EBO_DESCRIPTION="MSE - Multiple Sequence Screen Editor"
EBO_EAUTORECONF=1

inherit emboss-r2

KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="ncurses"

RDEPEND="ncurses? ( sys-libs/ncurses:0= )"

S="${WORKDIR}/MSE-3.0.0.650"

PATCHES=( "${FILESDIR}"/${PN}-3.0.0.650_fix-build-system.patch )

src_configure() {
	emboss-r2_src_configure $(use_enable ncurses curses)
}

src_install() {
	emboss-r2_src_install

	insinto /usr/include/emboss/mse
	doins h/*.h
}
