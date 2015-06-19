# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xloadimage/xloadimage-4.1-r11.ebuild,v 1.13 2014/12/05 22:20:11 ottxor Exp $

EAPI=2
inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="utility to view many different types of images under X11"
HOMEPAGE="http://world.std.com/~jimf/xloadimage.html"
SRC_URI="ftp://ftp.x.org/R5contrib/${P/-/.}.tar.gz
	mirror://gentoo/${P}-gentoo-r1.diff.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="tiff jpeg png"

RDEPEND="x11-libs/libX11
	tiff? ( media-libs/tiff )
	png? ( media-libs/libpng )
	jpeg? ( virtual/jpeg:0 )"
DEPEND="${RDEPEND}
	!media-gfx/xli"

S=${WORKDIR}/${P/-/.}

src_prepare() {
	epatch "${WORKDIR}"/${P}-gentoo-r1.diff
	epatch "${FILESDIR}"/${P}-zio-shell-meta-char.diff
	epatch "${FILESDIR}"/${P}-endif.patch

	# Do not define errno extern, but rather include errno.h
	# <azarah@gentoo.org> (1 Jan 2003)
	epatch "${FILESDIR}"/${P}-include-errno_h.patch

	epatch "${FILESDIR}"/xloadimage-gentoo.patch

	sed -i -e "s:OPT_FLAGS=:OPT_FLAGS=$CFLAGS:" Make.conf || die
	sed -i -e "s:^#include <varargs.h>:#include <stdarg.h>:" rlelib.c || die

	# On FreeBSD systems malloc.h is a false header asking for fixes.
	# On MacOSX it would require malloc/malloc.h
	# On other systems it's simply unneeded
	sed -i -e 's,<malloc.h>,<stdlib.h>,' vicar.c || die

	epatch "${FILESDIR}"/${P}-unaligned-access.patch
	epatch "${FILESDIR}"/${P}-ldflags_and_exit.patch

	sed -i -e "/^DEFS = /s:/etc:${EPREFIX}/etc:" Makefile.in

	epatch "${FILESDIR}"/${P}-libpng15.patch
	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:' \
		png.c || die

	# One of the previous patches screws up a bracket...
	epatch "${FILESDIR}"/${P}-bracket.patch

	chmod +x configure
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
	emake SYSPATHFILE="${EPREFIX}"/etc/X11/Xloadimage || die
}

src_install() {
	dobin xloadimage uufilter || die

	dosym xloadimage /usr/bin/xsetbg || die
	dosym xloadimage /usr/bin/xview || die

	insinto /etc/X11
	doins xloadimagerc || die

	newman xloadimage.man xloadimage.1 || die
	newman uufilter.man uufilter.1 || die

	echo ".so man1/xloadimage.1" > "${T}"/xsetbg.1
	doman "${T}"/xsetbg.1 || die
	newman "${T}"/xsetbg.1 xview.1 || die

	dodoc README
}
