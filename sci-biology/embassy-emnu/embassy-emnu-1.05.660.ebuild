# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EBO_DESCRIPTION="Simple menu of EMBOSS applications"

EBO_EAUTORECONF=1

inherit emboss-r2

KEYWORDS="~amd64 ~x86 ~x86-linux"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/EMNU-1.05.650"
PATCHES=( "${FILESDIR}"/${PN}-1.05.650_fix-build-system.patch )

src_configure() {
	# --disable-curses is not a thing,
	# EMNU hard depends on ncurses really, #752216
	emboss-r2_src_configure --enable-curses
}
