# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org toolchain-funcs

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	MY_PV=${PV/_/-}
	MY_P=${PN}-${MY_PV}
	if [[ ${PV} =~ beta[0-9]$ ]]; then
		SRC_URI="mirror://kde/unstable/${PN}/"
	else
		SRC_URI="mirror://kde/unstable/${PN}/${PV}/"
	fi
	SRC_URI+="${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Digital photo management application"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2"
SLOT="5"
IUSE="addressbook calendar gphoto2 heif +imagemagick +lensfun marble mediaplayer mysql opengl openmp +panorama scanner semantic-desktop vkontakte webkit X"

BDEPEND="
	>=dev-util/cmake-3.14.3
	sys-devel/gettext
	panorama? (
		sys-devel/bison
		sys-devel/flex
	)
"
COMMON_DEPEND="
	dev-libs/expat
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[-gles2-only]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[mysql?]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=media-gfx/exiv2-0.27:=
	media-libs/lcms:2
	media-libs/liblqr
	media-libs/libpng:0=
	>=media-libs/opencv-3.3.0:=[contrib,contribdnn]
	media-libs/tiff:0
	virtual/jpeg:0
	addressbook? (
		>=kde-apps/akonadi-contacts-19.04.3:5
		>=kde-frameworks/kcontacts-${KFMIN}:5
	)
	calendar? ( >=kde-frameworks/kcalendarcore-${KFMIN}:5 )
	gphoto2? ( media-libs/libgphoto2:= )
	heif? ( media-libs/x265:= )
	imagemagick? ( media-gfx/imagemagick:= )
	lensfun? ( media-libs/lensfun )
	marble? (
		>=dev-qt/qtconcurrent-${QTMIN}:5
		>=kde-apps/marble-19.04.3:5
		>=kde-frameworks/kbookmarks-${KFMIN}:5
	)
	mediaplayer? (
		media-libs/qtav[opengl]
		media-video/ffmpeg:=
	)
	opengl? (
		>=dev-qt/qtopengl-${QTMIN}:5
		virtual/opengl
	)
	panorama? ( >=kde-frameworks/threadweaver-${KFMIN}:5 )
	scanner? ( >=kde-apps/libksane-19.04.3:5 )
	semantic-desktop? ( >=kde-frameworks/kfilemetadata-${KFMIN}:5 )
	vkontakte? ( net-libs/libkvkontakte:5 )
	!webkit? ( >=dev-qt/qtwebengine-${QTMIN}:5[widgets] )
	webkit? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
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

PATCHES=( "${FILESDIR}"/${P}-qt-5.15.patch )

RESTRICT+=" test"
# bug 366505

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	ecm_pkg_pretend
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	ecm_pkg_setup
}

# FIXME: Unbundle libraw (libs/rawengine/libraw)
src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF # bug 698192
		-DENABLE_APPSTYLES=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
		-DENABLE_AKONADICONTACTSUPPORT=$(usex addressbook)
		$(cmake_use_find_package calendar KF5CalendarCore)
		$(cmake_use_find_package gphoto2 Gphoto2)
		$(cmake_use_find_package heif X265)
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

	ecm_src_configure
}
