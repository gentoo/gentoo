# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
COMMIT=8dd13df957af49cc793aed500f3a2a75c2c11548
PYTHON_COMPAT=( python3_{11..13} )
KFMIN=6.9.0
QTMIN=6.8.0
inherit ecm kde.org python-single-r1 xdg

DESCRIPTION="Free digital painting application. Digital Painting, Creative Freedom!"
HOMEPAGE="https://apps.kde.org/krita/ https://krita.org/en/"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/kde/${P}-${COMMIT:0:8}.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="color-management fftw gif +gsl heif jpeg2k jpegxl +mypaint-brush-engine openexr pdf media +raw webp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# bug 630508
RESTRICT="test"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-cpp/xsimd-13.0.0
	dev-libs/boost:=
	dev-libs/libunibreak:=
	>=dev-libs/quazip-1.3-r2:0=[qt6(+)]
	$(python_gen_cond_dep '
		dev-python/pyqt6[gui,qml,widgets,${PYTHON_USEDEP}]
		dev-python/sip:=[${PYTHON_USEDEP}]
	')
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,-gles2-only,gui,network,opengl,sql,wayland,widgets,X,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	media-gfx/exiv2:=
	media-libs/lcms
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/tiff:=
	virtual/zlib:=
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
	pdf? ( app-text/poppler[qt6(-)] )
	raw? ( kde-apps/libkdcraw:6 )
	webp? ( >=media-libs/libwebp-1.2.0:= )

"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
"
RDEPEND+=" || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 )"
DEPEND="${COMMON_DEPEND}
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
	"${FILESDIR}"/${PN}-5.3.0-tests-optional.patch
	"${FILESDIR}"/${PN}-5.2.2-fftw.patch # bug 913518
)

src_prepare() {
	rm -r packaging || die # unused and too low CMake minimum
	ecm_src_prepare
}

src_configure() {
	# Prevent sandbox violation from FindPyQt5.py module
	# See Gentoo-bug 655918
	addpredict /dev/dri

	local mycmakeargs=(
		-DBUILD_WITH_QT6=ON
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
		$(cmake_use_find_package raw KDcrawQt6)
		$(cmake_use_find_package webp WebP)
	)
	ecm_src_configure
}
