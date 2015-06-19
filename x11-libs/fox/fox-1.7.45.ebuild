# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fox/fox-1.7.45.ebuild,v 1.1 2014/01/10 18:26:56 mabi Exp $

EAPI=5

inherit fox

LICENSE="LGPL-2.1"
SLOT="1.7"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+bzip2 +jpeg +opengl +png tiff +truetype +zlib"

# newish autoconf needed for working mmap check
RDEPEND="x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/fox-wrapper
	>=sys-devel/autoconf-2.67
	bzip2? ( app-arch/bzip2 )
	jpeg? ( virtual/jpeg )
	opengl? ( virtual/glu virtual/opengl )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	truetype? ( media-libs/freetype:2
		x11-libs/libXft )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-libs/libXt"

src_configure() {
	FOXCONF="$(use_enable bzip2 bz2lib) \
		$(use_enable jpeg) \
		$(use_with opengl) \
		$(use_enable png) \
		$(use_enable tiff) \
		$(use_with truetype xft) \
		$(use_enable zlib)" fox_src_configure
}

src_install() {
	fox_src_install
	CP="${ED}/usr/bin/ControlPanel"
	if [[ -f ${CP} ]] ; then
		mv "${CP}" "${ED}/usr/bin/fox-ControlPanel-${SLOT}" || \
			die "Failed to install ControlPanel"
	fi
}

pkg_postinst() {
	fox_pkg_postinst

	einfo "ControlPanel has been installed to 'fox-ControlPanel-${SLOT}' to avoid conflicts"
	einfo "with other packages."
}
