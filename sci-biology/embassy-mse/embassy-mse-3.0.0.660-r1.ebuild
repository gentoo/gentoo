# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="MSE - Multiple Sequence Screen Editor"

inherit autotools emboss-r3 flag-o-matic

KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/MSE-3.0.0.650"
PATCHES=( "${FILESDIR}"/${PN}-3.0.0.650_fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/927386
	#
	# Upstream is dead since 2013.
	filter-lto

	emboss-r3_src_configure --enable-curses
}

src_install() {
	emboss-r3_src_install

	insinto /usr/include/emboss/mse
	doins h/*.h
}
