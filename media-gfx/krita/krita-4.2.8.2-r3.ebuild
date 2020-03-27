# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
PYTHON_COMPAT=( python3_{6,7,8} )
KFMIN=5.60.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org python-single-r1

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/$(ver_cut 1-3)/${P}.tar.xz
		https://dev.gentoo.org/~asturm/distfiles/${P}-patchset.tar.xz"
	KEYWORDS="amd64 ~ppc64 ~x86"
fi

DESCRIPTION="Free digital painting application. Digital Painting, Creative Freedom!"
HOMEPAGE="https://kde.org/applications/graphics/org.kde.krita https://krita.org/en/"

LICENSE="GPL-3"
SLOT="5"
IUSE="color-management fftw gif +gsl heif +jpeg openexr pdf qtmedia +raw tiff vc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-cpp/eigen:3
	dev-lang/perl
	sys-devel/gettext
"
RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=
	dev-libs/quazip
	$(python_gen_cond_dep '
		dev-python/PyQt5[${PYTHON_MULTI_USEDEP}]
		dev-python/sip[${PYTHON_MULTI_USEDEP}]
	')
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=[-gles2-only]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
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
	qtmedia? ( >=dev-qt/qtmultimedia-${QTMIN}:5 )
	raw? ( media-libs/libraw:= )
	tiff? ( media-libs/tiff:0 )
"
DEPEND="${RDEPEND}
	vc? ( >=dev-libs/vc-1.1.0 )
"

# bug 630508
RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.4-tests-optional.patch
	"${WORKDIR}"/${P}-patchset
)

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
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

	ecm_src_configure
}
