# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PYTHON_COMPAT=( python3_{11..13} )
KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm kde.org python-single-r1

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Free digital painting application. Digital Painting, Creative Freedom!"
HOMEPAGE="https://apps.kde.org/krita/ https://krita.org/en/"

LICENSE="GPL-3"
SLOT="5"
IUSE="color-management fftw gif +gsl heif jpeg2k jpegxl +mypaint-brush-engine openexr pdf media +raw +xsimd webp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# bug 630508
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=
	dev-libs/libunibreak:=
	>=dev-libs/quazip-1.3-r2:=[qt5(-)]
	$(python_gen_cond_dep '
		dev-python/pyqt5[declarative,gui,widgets,${PYTHON_USEDEP}]
		dev-python/sip:=[${PYTHON_USEDEP}]
	')
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=[-gles2-only]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
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
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXi
	color-management? ( >=media-libs/opencolorio-2.0.0 )
	fftw? ( sci-libs/fftw:3.0= )
	gif? ( media-libs/giflib )
	gsl? ( sci-libs/gsl:= )
	jpeg2k? ( media-libs/openjpeg:= )
	jpegxl? ( >=media-libs/libjxl-0.7.0_pre20220825:= )
	heif? ( >=media-libs/libheif-1.11:=[x265] )
	media? ( media-libs/mlt:= )
	mypaint-brush-engine? ( media-libs/libmypaint:= )
	openexr? ( media-libs/openexr:= )
	pdf? ( app-text/poppler[qt5] )
	raw? ( kde-apps/libkdcraw:5 )
	webp? ( >=media-libs/libwebp-1.2.0:= )
	xsimd? ( >=dev-cpp/xsimd-13.0.0 )

"
DEPEND="${RDEPEND}
	dev-libs/immer
	dev-libs/lager
	dev-libs/zug
"
BDEPEND="
	dev-cpp/eigen:3
	dev-lang/perl
	sys-devel/gettext
"

PATCHES=(
	# downstream
	"${FILESDIR}"/${PN}-5.2.3-tests-optional.patch
	"${FILESDIR}"/${PN}-5.2.2-fftw.patch # bug 913518
	# git master
	"${FILESDIR}"/${PN}-5.1.5-sip-6.8.patch # bug 919139
	# somewhere... upstream... but not in the 5.2.11 tag.
	"${FILESDIR}"/${P}-libheif-1.20.patch # bug 959940
)

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_prepare() {
	ecm_src_prepare
	cmake_comment_add_subdirectory benchmarks # bug 939842
}

src_configure() {
	# Prevent sandbox violation from FindPyQt5.py module
	# See Gentoo-bug 655918
	addpredict /dev/dri

	local mycmakeargs=(
		-DENABLE_UPDATERS=OFF
		-DKRITA_ENABLE_PCH=OFF # big mess.
		-DCMAKE_DISABLE_FIND_PACKAGE_KSeExpr=ON # not packaged
		$(cmake_use_find_package color-management OpenColorIO)
		$(cmake_use_find_package fftw FFTW3)
		$(cmake_use_find_package gif GIF)
		$(cmake_use_find_package gsl GSL)
		$(cmake_use_find_package heif HEIF)
		$(cmake_use_find_package jpeg2k OpenJPEG)
		$(cmake_use_find_package jpegxl JPEGXL)
		$(cmake_use_find_package media Mlt7)
		$(cmake_use_find_package mypaint-brush-engine LibMyPaint)
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package pdf Poppler)
		$(cmake_use_find_package raw KF5KDcraw)
		$(cmake_use_find_package webp WebP)
		$(cmake_use_find_package xsimd xsimd)
	)

	ecm_src_configure
}
