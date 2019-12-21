# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
PYTHON_COMPAT=( python3_{6,7} )
inherit kde5 python-single-r1

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="Free digital painting application. Digital Painting, Creative Freedom!"
HOMEPAGE="https://kde.org/applications/graphics/krita/ https://krita.org/"
LICENSE="GPL-3"
IUSE="color-management fftw gif +gsl heif +jpeg openexr pdf qtmedia +raw tiff vc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-cpp/eigen:3
	dev-lang/perl
	sys-devel/gettext
"
COMMON_DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui '-gles2' '' '5=')
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	dev-libs/boost:=
	dev-libs/quazip
	dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	media-gfx/exiv2:=
	media-libs/lcms
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXi
	color-management? ( media-libs/opencolorio )
	fftw? ( sci-libs/fftw:3.0= )
	gif? ( media-libs/giflib )
	gsl? ( sci-libs/gsl:= )
	jpeg? ( virtual/jpeg:0 )
	heif? ( media-libs/libheif:= )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr
	)
	pdf? ( app-text/poppler[qt5] )
	qtmedia? ( $(add_qt_dep qtmultimedia) )
	raw? ( media-libs/libraw:= )
	tiff? ( media-libs/tiff:0 )
"
DEPEND="${COMMON_DEPEND}
	vc? ( >=dev-libs/vc-1.1.0 )
"
RDEPEND="${COMMON_DEPEND}
	!app-office/calligra:4[calligra_features_krita]
	!app-office/calligra-l10n:4[calligra_features_krita(+)]
"

# bug 630508
RESTRICT+=" test"

PATCHES=( "${FILESDIR}"/${PN}-4.2.4-tests-optional.patch )

pkg_setup() {
	python-single-r1_pkg_setup
	kde5_pkg_setup
}

src_configure() {
	# Prevent sandbox violation from FindPyQt5.py module
	# See Gentoo-bug 655918
	addpredict /dev/dri

	local mycmakeargs=(
		$(cmake_use_find_package color-management OCIO)
		$(cmake_use_find_package fftw FFTW3)
		$(cmake_use_find_package gif GIF)
		$(cmake_use_find_package gsl GSL)
		$(cmake_use_find_package heif HEIF)
		$(cmake_use_find_package jpeg JPEG)
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package pdf Poppler)
		$(cmake_use_find_package qtmedia Qt5Multimedia)
		$(cmake_use_find_package raw LibRaw)
		$(cmake_use_find_package tiff TIFF)
		$(cmake_use_find_package vc Vc)
	)

	kde5_src_configure
}
