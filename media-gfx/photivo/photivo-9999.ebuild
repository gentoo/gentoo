# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2 mercurial

DESCRIPTION="Photo processor for RAW and Bitmap images"
HOMEPAGE="http://www.photivo.org"
EHG_REPO_URI="https://bitbucket.org/Photivo/photivo"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gimp"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	|| ( virtual/jpeg:62 media-libs/jpeg:62 )
	media-gfx/exiv2
	media-libs/cimg
	media-libs/lcms:2
	media-libs/lensfun
	sci-libs/fftw:3.0
	media-libs/liblqr
	media-gfx/graphicsmagick[q16,-lcms]
	gimp? ( media-gfx/gimp )"
DEPEND="${RDEPEND}"

src_prepare() {
	# remove ccache dependency
	local File
	for File in $(find "${S}" -type f); do
		if grep -sq ccache ${File}; then
			sed -e 's/ccache//' -i "${File}" || die
		fi
	done

	# bug 560120 - fix includes for lensfun.h
	sed -s -e 's:lensfun.h:lensfun\/lensfun.h:' \
		-i ReferenceMaterial/LensFunSample.c \
		-i Sources/ptConstants.h \
		-i Sources/ptImage.h \
		-i Sources/ptImage_Lensfun.cpp \
		-i Sources/ptLensfun.h || die

	# useless check (no pkgconfig file is provided)
	sed -e "/PKGCONFIG += CImg/d" \
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
