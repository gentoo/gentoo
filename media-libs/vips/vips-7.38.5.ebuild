# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils versionator python-single-r1

DESCRIPTION="VIPS Image Processing Library"
SRC_URI="http://www.vips.ecs.soton.ac.uk/supported/$(get_version_component_range 1-2)/${P}.tar.gz"
HOMEPAGE="http://www.vips.ecs.soton.ac.uk/index.php?title=VIPS"

RESTRICT="mirror"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="cxx debug exif fits fftw imagemagick jpeg lcms matio openexr
	+orc png python static-libs tiff webp"

RDEPEND=">=dev-libs/glib-2.6:2
	dev-libs/libxml2
	sys-libs/zlib
	>=x11-libs/pango-1.8
	fftw? ( sci-libs/fftw:3.0 )
	imagemagick? ( || ( >=media-gfx/imagemagick-5.0.0
		media-gfx/graphicsmagick[imagemagick] ) )
	lcms? ( media-libs/lcms )
	matio? ( >=sci-libs/matio-1.3.4 )
	openexr? ( >=media-libs/openexr-1.2.2 )
	exif? ( >=media-libs/libexif-0.6 )
	tiff? ( media-libs/tiff:0= )
	jpeg? ( virtual/jpeg:0= )
	fits? ( sci-libs/cfitsio )
	png? ( >=media-libs/libpng-1.2.9:0= )
	python? ( ${PYTHON_DEPS} )
	webp? ( media-libs/libwebp )
	orc? ( >=dev-lang/orc-0.4.11 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable cxx) \
		$(use_with fftw) \
		$(use_with lcms) \
		$(use_with openexr OpenEXR) \
		$(use_with matio ) \
		$(use_with exif libexif) \
		$(use_with imagemagick magick) \
		$(use_with png) \
		$(use_with tiff) \
		$(use_with fits cfitsio) \
		$(use_with jpeg) \
		$(use_with orc) \
		$(use_with python) \
		$(use_with webp libwebp) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS THANKS TODO

	# 314101
	mv "${ED}"/usr/share/doc/${PN}/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/${PN}/ || die
	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}

	use python && python_optimize
	prune_libtool_files
}
