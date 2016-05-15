# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MYP=dx-${PV}
inherit eutils flag-o-matic autotools multilib

DESCRIPTION="3D data visualization tool"
HOMEPAGE="http://www.opendx.org/"
SRC_URI="http://opendx.sdsc.edu/source/${MYP}.tar.gz"

LICENSE="IBM"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="hdf cdf netcdf tiff imagemagick szip smp"

RDEPEND="x11-libs/libXmu
	x11-libs/libXi
	x11-libs/libXp
	x11-libs/libXpm
	>=x11-libs/motif-2.3:0
	virtual/opengl
	virtual/glu
	szip? ( virtual/szip )
	hdf? ( sci-libs/hdf )
	cdf? ( sci-libs/cdf )
	netcdf? ( sci-libs/netcdf )
	tiff? ( media-libs/tiff:0 )
	imagemagick? ( media-gfx/imagemagick )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-4.3.2-sys.h.patch"
	epatch "${FILESDIR}/${P}-installpaths.patch"
	epatch "${FILESDIR}/${P}-xdg.patch"
	epatch "${FILESDIR}/${P}-gcc43.patch"
	epatch "${FILESDIR}/${P}-dx-errno.patch"
	epatch "${FILESDIR}/${P}-libtool.patch"
	epatch "${FILESDIR}/${P}-concurrent-make-fix.patch"
	epatch "${FILESDIR}/${P}-open.patch"
	epatch "${FILESDIR}/${P}-szip.patch"
	epatch "${FILESDIR}/${P}-null.patch"
	eautoreconf
}

src_configure() {
	# check flag filtering
	# with gcc 3.3.2 I had an infinite loop on src/exec/libdx/zclipQ.c
	append-flags -fno-strength-reduce

	# (#82672)
	filter-flags -finline-functions
	replace-flags -O3 -O2

	# opendx uses this variable
	unset ARCH

	# javadx is currently broken. we may try to fix it someday.
	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--with-x \
		--without-javadx \
		$(use_with szip szlib) \
		$(use_with cdf) \
		$(use_with netcdf) \
		$(use_with hdf) \
		$(use_with tiff) \
		$(use_with imagemagick magick) \
		$(use_enable smp smp-linux)
}

src_install() {
	default
	newicon src/uipp/ui/icon50.xpm ${PN}.xpm
	make_desktop_entry dx "Open Data Explorer"
}
