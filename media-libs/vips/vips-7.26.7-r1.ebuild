# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="python? 2"
inherit eutils versionator python

# TODO:
# matio? ( sci-libs/matio ) - in science overlay #269598 (wait for new release
# after 1.3.4) or until somebody adds it to the tree.

DESCRIPTION="VIPS Image Processing Library"
SRC_URI="http://www.vips.ecs.soton.ac.uk/supported/$(get_version_component_range 1-2)/${P}.tar.gz"
HOMEPAGE="http://vips.sourceforge.net"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="debug exif fits fftw imagemagick jpeg lcms openexr png python static-libs tiff"

RDEPEND=">=dev-lang/orc-0.4.11
	>=dev-libs/glib-2.6:2
	dev-libs/libxml2
	sys-libs/zlib
	>=x11-libs/pango-1.8
	fftw? ( sci-libs/fftw:3.0 )
	imagemagick? ( || ( >=media-gfx/imagemagick-5.0.0
		media-gfx/graphicsmagick[imagemagick] ) )
	lcms? ( media-libs/lcms )
	openexr? ( >=media-libs/openexr-1.2.2 )
	exif? ( >=media-libs/libexif-0.6 )
	tiff? ( media-libs/tiff )
	jpeg? ( virtual/jpeg )
	fits? ( sci-libs/cfitsio )
	png? ( >=media-libs/libpng-1.2.9 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_with fftw fftw3) \
		$(use_with lcms) \
		$(use_with openexr OpenEXR) \
		$(use_with exif libexif) \
		$(use_with imagemagick magick) \
		$(use_with png) \
		$(use_with tiff) \
		$(use_with fits cfitsio) \
		$(use_with jpeg) \
		$(use_with orc) \
		$(use_with python) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die

	# 314101
	mv "${ED}"/usr/share/doc/${PN}/* "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/${PN}/ || die
	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}

	find "${ED}" -name '*.la' -exec rm -f {} +
}
