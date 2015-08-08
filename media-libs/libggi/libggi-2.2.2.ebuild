# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Fast and safe graphics and drivers for about any graphics card to the Linux kernel (sometimes)"
HOMEPAGE="http://www.ggi-project.org"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="X aalib svga fbcon directfb 3dfx debug cpu_flags_x86_mmx vis"

RDEPEND=">=media-libs/libgii-1.0.2
	X? ( x11-libs/libXt
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
		x11-libs/libXt )
	svga? ( >=media-libs/svgalib-1.4.2 )
	aalib? ( >=media-libs/aalib-1.2-r1 )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xf86dgaproto
		x11-proto/xf86vidmodeproto
		x11-proto/xextproto )"

src_compile() {
	local myconf=""

	use svga || myconf="${myconf} --disable-svga --disable-vgagl"

	if use !fbcon && use !directfb; then
		myconf="${myconf} --disable-fbdev --disable-directfb"
	elif use directfb; then
		myconf="${myconf} --enable-fbdev --enable-directfb"
	else
		myconf="${myconf} --enable-fbdev"
	fi

	if use amd64 || use ppc64 || use ia64 ; then
		myconf="${myconf} --enable-64bitc"
	else
		myconf="${myconf} --disable-64bitc"
	fi

	econf $(use_enable 3dfx glide) \
		$(use_enable aalib aa) \
		$(use_enable debug) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable vis) \
		$(use_with X x) \
		$(use_enable X x) \
		${myconf}
	emake || die
}

src_install () {
	emake DESTDIR="${D}" install || die

	dodoc ChangeLog* FAQ NEWS README
	docinto txt
	dodoc doc/*.txt
}
