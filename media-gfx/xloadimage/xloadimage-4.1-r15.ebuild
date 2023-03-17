# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Utility to view many different types of images under X11"
HOMEPAGE="https://sioseis.ucsd.edu/xloadimage.html https://tracker.debian.org/pkg/xloadimage"
SRC_URI="
	ftp://ftp.x.org/R5contrib/${P/-/.}.tar.gz
	mirror://gentoo/${P}-gentoo-r1.diff.bz2
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-fix-build-for-clang16.patch.xz
"
S="${WORKDIR}"/${P/-/.}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="tiff jpeg png"

RDEPEND="x11-libs/libX11
	tiff? ( media-libs/tiff:= )
	png? ( media-libs/libpng:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	!media-gfx/xli"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}"/${P}-gentoo-r1.diff
	"${FILESDIR}"/${P}-zio-shell-meta-char.diff
	"${FILESDIR}"/${P}-endif.patch
	# Do not define errno extern, but rather include errno.h
	# <azarah@gentoo.org> (1 Jan 2003)
	"${FILESDIR}"/${P}-include-errno_h.patch
	"${FILESDIR}"/xloadimage-gentoo.patch
	"${FILESDIR}"/${P}-unaligned-access.patch
	"${FILESDIR}"/${P}-ldflags_and_exit.patch
	"${FILESDIR}"/${P}-libpng15.patch
	"${WORKDIR}"/${P}-fix-build-for-clang16.patch
	# One of the previous patches screws up a bracket...
	"${FILESDIR}"/${P}-bracket.patch
)

src_prepare() {
	default

	sed -i -e "s:OPT_FLAGS=:OPT_FLAGS=$CFLAGS:" Make.conf || die
	sed -i -e "s:^#include <varargs.h>:#include <stdarg.h>:" rlelib.c || die
	# qa-sed sees no-op on the next sed on non-gentoo-prefix systems,
	# but that is alright
	sed -i -e "/^DEFS = /s:/etc:${EPREFIX}/etc:" Makefile.in || die
	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:' \
		png.c || die

	eautoreconf
}

src_configure() {
	# Set TIFFHeader to TIFFHeaderCommon wrt #319383
	has_version '>=media-libs/tiff-4.0.0_pre' && \
		append-flags -DTIFFHeader=TIFFHeaderCommon

	tc-export CC
	econf $(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff)
}

src_compile() {
	emake SYSPATHFILE="${EPREFIX}"/etc/X11/Xloadimage
}

src_install() {
	dobin xloadimage uufilter

	dosym xloadimage /usr/bin/xsetbg
	dosym xloadimage /usr/bin/xview

	insinto /etc/X11
	doins xloadimagerc

	newman xloadimage.man xloadimage.1
	newman uufilter.man uufilter.1

	echo ".so man1/xloadimage.1" > "${T}"/xsetbg.1 || die
	doman "${T}"/xsetbg.1
	newman "${T}"/xsetbg.1 xview.1

	dodoc README
}
