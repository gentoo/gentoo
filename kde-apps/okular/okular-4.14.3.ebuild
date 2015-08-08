# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"

#VIRTUALX_REQUIRED=test
RESTRICT=test
# test 2: parttest hangs

inherit kde4-base

DESCRIPTION="Okular is a universal document viewer based on KPDF for KDE 4"
HOMEPAGE="http://okular.kde.org http://www.kde.org/applications/graphics/okular"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="chm crypt debug djvu dpi ebook +jpeg mobi +postscript +pdf +tiff"

DEPEND="
	media-libs/freetype
	media-libs/qimageblitz
	sys-libs/zlib
	chm? ( dev-libs/chmlib )
	crypt? ( app-crypt/qca:2[qt4(+)] )
	djvu? ( app-text/djvu )
	dpi? ( x11-libs/libkscreen:4 )
	ebook? ( app-text/ebook-tools )
	jpeg? (
		$(add_kdeapps_dep libkexiv2)
		virtual/jpeg:0
	)
	mobi? ( $(add_kdeapps_dep kdegraphics-mobipocket) )
	pdf? ( >=app-text/poppler-0.20[qt4,-exceptions(-)] )
	postscript? ( app-text/libspectre )
	tiff? ( media-libs/tiff )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with chm)
		$(cmake-utils_use_with crypt QCA2)
		$(cmake-utils_use_with djvu DjVuLibre)
		$(cmake-utils_use_with dpi LibKScreen)
		$(cmake-utils_use_with ebook EPub)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with jpeg Kexiv2)
		$(cmake-utils_use_with mobi QMobiPocket)
		$(cmake-utils_use_with postscript LibSpectre)
		$(cmake-utils_use_with pdf PopplerQt4)
		$(cmake-utils_use_with pdf Poppler)
		$(cmake-utils_use_with tiff)
	)

	kde4-base_src_configure
}
