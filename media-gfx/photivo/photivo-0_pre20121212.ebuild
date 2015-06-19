# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/photivo/photivo-0_pre20121212.ebuild,v 1.1 2013/03/07 21:10:14 hwoarang Exp $

EAPI=4

inherit qt4-r2

DESCRIPTION="Photo processor for RAW and Bitmap images"
HOMEPAGE="http://www.photivo.org"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gimp"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	virtual/jpeg
	media-libs/tiff
	media-libs/libpng
	media-gfx/exiv2
	media-libs/lcms:2
	media-libs/lensfun
	sci-libs/fftw:3.0
	media-libs/liblqr
	media-gfx/graphicsmagick[q16,-lcms]
	media-gfx/greycstoration[lapack]
	virtual/lapack
	media-libs/cimg
	gimp? ( media-gfx/gimp )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${PV/0_pre/}

src_prepare() {
	# remove ccache dependency
	local File
	for File in $(find "${S}" -type f); do
		if grep -sq ccache ${File}; then
			sed -e 's/ccache//' -i "${File}"
		fi
	done

	# useless check (no pkgconfig file is provided)
	sed -e "/PKGCONFIG  += CImg/d" \
		-i photivoProject/photivoProject.pro || die
	qt4-r2_src_prepare
}

src_configure() {
	local config="WithSystemCImg"
	if use gimp ; then
		config+=" WithGimp"
	fi

	eqmake4 "CONFIG+=${config}"
}

src_install() {
	qt4-r2_src_install

	if use gimp; then
		exeinto $(gimptool-2.0 --gimpplugindir)/plug-ins
		doexe ptGimp
		doexe "mm extern photivo.py"
	fi
}
