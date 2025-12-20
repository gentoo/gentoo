# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="Simple menu of EMBOSS applications"

inherit autotools emboss-r3

KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/EMNU-1.05.650"
PATCHES=( "${FILESDIR}"/${PN}-1.05.650_fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# --disable-curses is not a thing,
	# EMNU hard depends on ncurses really, #752216
	emboss-r3_src_configure --enable-curses
}
