# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5 toolchain-funcs

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	MY_PV=${PV/_/-}
	MY_P=${PN}-${MY_PV}
	SRC_BRANCH=stable
	[[ ${PV} =~ beta[0-9]$ ]] && SRC_BRANCH=unstable
	SRC_URI="mirror://kde/${SRC_BRANCH}/digikam/${PV}/${MY_P}.tar.xz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Digital photo management application"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2"
IUSE="addressbook calendar dnn +imagemagick gphoto2 +lensfun libav marble mediaplayer mysql opengl openmp +panorama scanner semantic-desktop vkontakte webkit X"

BDEPEND="
	>=dev-util/cmake-3.14.3
	sys-devel/gettext
	panorama? (
		sys-devel/bison
		sys-devel/flex
	)
"
COMMON_DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui '-gles2')
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql 'mysql?')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	dev-libs/expat
	>=media-gfx/exiv2-0.26:=
	media-libs/lcms:2
	media-libs/liblqr
	media-libs/libpng:0=
	>=media-libs/opencv-3.1.0:=
	media-libs/tiff:0
	virtual/jpeg:0
	addressbook? (
		|| (
			$(add_frameworks_dep kcontacts)
			$(add_kdeapps_dep kcontacts)
		)
		$(add_kdeapps_dep akonadi-contacts)
	)
	calendar? ( || (
		$(add_frameworks_dep kcalendarcore)
		$(add_kdeapps_dep kcalcore)
	) )
	dnn? ( >=media-libs/opencv-3.1.0:=[contrib,contribdnn] )
	gphoto2? ( media-libs/libgphoto2:= )
	imagemagick? ( media-gfx/imagemagick:= )
	lensfun? ( media-libs/lensfun )
	marble? (
		$(add_frameworks_dep kbookmarks)
		$(add_kdeapps_dep marble)
		$(add_qt_dep qtconcurrent)
	)
	mediaplayer? (
		media-libs/qtav[opengl]
		!libav? ( media-video/ffmpeg:= )
		libav? ( media-video/libav:= )
	)
	opengl? (
		$(add_qt_dep qtopengl)
		virtual/opengl
	)
	panorama? ( $(add_frameworks_dep threadweaver) )
	scanner? ( $(add_kdeapps_dep libksane) )
	semantic-desktop? ( $(add_frameworks_dep kfilemetadata) )
	vkontakte? ( net-libs/libkvkontakte:5 )
	!webkit? ( $(add_qt_dep qtwebengine 'widgets') )
	webkit? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:3
	dev-libs/boost[threads]
"
RDEPEND="${COMMON_DEPEND}
	mysql? ( virtual/mysql[server] )
	panorama? ( media-gfx/hugin )
"

RESTRICT+=" test"
# bug 366505

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-googlephoto-import-crash.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	kde5_pkg_pretend
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	kde5_pkg_setup
}

# FIXME: Unbundle libraw (libs/rawengine/libraw)
src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF # bug #698192
		-DENABLE_APPSTYLES=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
		-DENABLE_AKONADICONTACTSUPPORT=$(usex addressbook)
		$(cmake_use_find_package calendar KF5CalendarCore)
		-DENABLE_FACESENGINE_DNN=$(usex dnn)
		$(cmake_use_find_package gphoto2 Gphoto2)
		$(cmake_use_find_package imagemagick ImageMagick)
		$(cmake_use_find_package lensfun LensFun)
		$(cmake_use_find_package marble Marble)
		-DENABLE_MEDIAPLAYER=$(usex mediaplayer)
		$(cmake_use_find_package mediaplayer QtAV)
		-DENABLE_MYSQLSUPPORT=$(usex mysql)
		-DENABLE_INTERNALMYSQL=$(usex mysql)
		$(cmake_use_find_package opengl OpenGL)
		$(cmake_use_find_package panorama KF5ThreadWeaver)
		$(cmake_use_find_package scanner KF5Sane)
		$(cmake_use_find_package semantic-desktop KF5FileMetaData)
		$(cmake_use_find_package vkontakte KF5Vkontakte)
		-DENABLE_QWEBENGINE=$(usex !webkit)
		$(cmake_use_find_package X X11)
	)

	kde5_src_configure
}
