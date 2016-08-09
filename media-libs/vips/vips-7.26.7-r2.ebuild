# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 versionator

# TODO:
# matio? ( sci-libs/matio ) - in science overlay #269598 (wait for new release
# after 1.3.4) or until somebody adds it to the tree.

DESCRIPTION="VIPS Image Processing Library"
SRC_URI="http://www.vips.ecs.soton.ac.uk/supported/$(get_version_component_range 1-2)/${P}.tar.gz"
HOMEPAGE="http://vips.sourceforge.net"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="debug exif fits fftw imagemagick jpeg lcms openexr orc png python static-libs tiff"

RDEPEND=">=dev-libs/glib-2.6:2
	dev-libs/libxml2
	sys-libs/zlib
	>=x11-libs/pango-1.8
	orc? ( >=dev-lang/orc-0.4.11 )
	fftw? ( sci-libs/fftw:3.0= )
	imagemagick? ( || ( >=media-gfx/imagemagick-5.0.0
		media-gfx/graphicsmagick[imagemagick-compat] ) )
	lcms? ( media-libs/lcms )
	openexr? ( >=media-libs/openexr-1.2.2 )
	exif? ( >=media-libs/libexif-0.6 )
	tiff? ( media-libs/tiff:0 )
	jpeg? ( virtual/jpeg:0 )
	fits? ( sci-libs/cfitsio )
	png? ( >=media-libs/libpng-1.2.9:0= )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	python? ( ${PYTHON_DEPS} )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/${P}-qa-implicit-declarations.patch"
)

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_with exif libexif) \
		$(use_with fits cfitsio) \
		$(use_with fftw fftw3) \
		$(use_with imagemagick magick) \
		$(use_with jpeg) \
		$(use_with lcms) \
		$(use_with openexr OpenEXR) \
		$(use_with orc) \
		$(use_with png) \
		$(use_with python) \
		$(use_with tiff)
}

src_install() {
	default

	# bug 314101
	mv "${ED}"usr/share/doc/${PN}/* "${ED}"usr/share/doc/${PF} || die
	rm -rf "${ED}"usr/share/doc/${PN}/ || die
	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}

	find "${ED}" -name '*.la' -delete || die
}
