# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV=$(ver_cut 1-3)
MY_PATCH_MAJ=$(ver_cut 5)
MY_PATCH_MIN=$(ver_cut 7)

DESCRIPTION="Library for overlaying text in X-Windows X-On-Screen-Display"
HOMEPAGE="https://sourceforge.net/projects/libxosd/"
SRC_URI="mirror://debian/pool/main/x/xosd/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/x/xosd/${PN}_${MY_PV}-${MY_PATCH_MAJ/p/}.${MY_PATCH_MIN/p/}.debian.tar.xz
	http://digilander.libero.it/dgp85/gentoo/${PN}-gentoo-m4-1.tar.bz2"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="static-libs xinerama"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	media-fonts/font-misc-misc"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

DOCS=(
	AUTHORS ChangeLog NEWS README TODO
)

PATCHES=(
	"${WORKDIR}"/debian/patches/20_underquoted_definition.diff
	"${WORKDIR}"/debian/patches/25_fix_mangapges.diff
	"${WORKDIR}"/debian/patches/30_aclocal.diff
	"${WORKDIR}"/debian/patches/328676.diff
	"${WORKDIR}"/debian/patches/35_beep_media_player.diff
	"${WORKDIR}"/debian/patches/54_fix_man_makefile.diff
	# bug #286632
	"${FILESDIR}"/${PN}-config-incorrect-dup-filter-fix.patch
)

src_prepare() {
	default

	AT_M4DIR="${WORKDIR}"/m4 eautoreconf
}

src_configure() {
	econf \
		$(use_enable xinerama) \
		$(use_enable static-libs static)
}
