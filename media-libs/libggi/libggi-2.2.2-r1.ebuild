# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides an opaque interface to the display's acceleration function"
HOMEPAGE="https://ibiblio.org/ggicore/packages/libggi.html"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="3dfx aalib cpu_flags_x86_mmx debug fbcon svga vis X"

RDEPEND=">=media-libs/libgii-1.0.2
	aalib? ( >=media-libs/aalib-1.2-r1 )
	svga? ( >=media-libs/svgalib-1.4.2 )
	X? (
		x11-libs/libXt
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
	)"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

DOCS=( ChangeLog ChangeLog.1999 FAQ NEWS README )

src_configure() {
	local myconf=""

	use svga || myconf="${myconf} --disable-svga --disable-vgagl"

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
		$(use_enable fbcon fbdev) \
		--disable-directfb \
		--disable-static \
		${myconf}
}

src_install(){
	default

	docinto txt
	dodoc doc/*.txt

	find "${D}" -name '*.la' -delete || die
}
