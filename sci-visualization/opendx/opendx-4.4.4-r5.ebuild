# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MYP=dx-${PV}

inherit autotools eutils flag-o-matic

DESCRIPTION="3D data visualization tool"
HOMEPAGE="http://www.opendx.org/"
SRC_URI="http://opendx.sdsc.edu/source/${MYP}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${PN}-4.4.4_p20160917-fix-c++14.patch.bz2"

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
PATCHES=(
	"${FILESDIR}/${PN}-4.3.2-sys.h.patch"
	"${FILESDIR}/${P}-installpaths.patch"
	"${FILESDIR}/${P}-xdg.patch"
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-dx-errno.patch"
	"${FILESDIR}/${P}-libtool.patch"
	"${FILESDIR}/${P}-concurrent-make-fix.patch"
	"${FILESDIR}/${P}-open.patch"
	"${FILESDIR}/${P}-szip.patch"
	"${FILESDIR}/${P}-null.patch"
	"${WORKDIR}/${PN}-4.4.4_p20160917-fix-c++14.patch"
)

src_prepare() {
	default
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
