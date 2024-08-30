# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm kde.org toolchain-funcs

DESCRIPTION="Digital photo management application"
HOMEPAGE="https://www.digikam.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/digiKam-${PV/_/-}.tar.xz
	https://dev.gentoo.org/~asturm/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="addressbook calendar geolocation gphoto2 heif +imagemagick jpegxl +lensfun mysql openmp +panorama scanner semantic-desktop spell video"

# bug 366505
RESTRICT="test"

COMMON_DEPEND="
	dev-libs/expat
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,dbus,-gles2-only,gui,mysql?,network,opengl,sql,widgets,xml]
	>=dev-qt/qtnetworkauth-${QTMIN}:6
	>=dev-qt/qtscxml-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=media-gfx/exiv2-0.27.1:=[xmp]
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/liblqr
	media-libs/libpng:=
	>=media-libs/opencv-3.3.0:=[contrib,contribdnn,features2d]
	media-libs/tiff:=
	virtual/opengl
	x11-libs/libX11
	addressbook? (
		>=kde-apps/akonadi-contacts-24.05.2:6
		>=kde-frameworks/kcontacts-${KFMIN}:6
	)
	calendar? ( >=kde-frameworks/kcalendarcore-${KFMIN}:6 )
	gphoto2? ( media-libs/libgphoto2:= )
	heif? (
		media-libs/libheif:=
		media-libs/x265:=
	)
	imagemagick? ( media-gfx/imagemagick:= )
	jpegxl? ( media-libs/libjxl:= )
	lensfun? ( media-libs/lensfun )
	panorama? ( >=kde-frameworks/threadweaver-${KFMIN}:6 )
	scanner? ( >=kde-apps/libksane-24.05.2:6 )
	semantic-desktop? ( >=kde-frameworks/kfilemetadata-${KFMIN}:6 )
	spell? ( >=kde-frameworks/sonnet-${KFMIN}:6 )
	video? ( >=dev-qt/qtmultimedia-${QTMIN}:6 )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:3
	dev-libs/boost
	addressbook? ( >=kde-apps/akonadi-24.05.2:6 )
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
	media-libs/exiftool
	mysql? ( virtual/mysql[server(+)] )
	panorama? ( media-gfx/hugin )
"
BDEPEND="
	sys-devel/gettext
	panorama? (
		app-alternatives/lex
		app-alternatives/yacc
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-8.4.0-cmake.patch"
	"${FILESDIR}/${PN}-8.3.0-cmake-addressbook.patch"
	# bug 936507; KDE-bugs 488662, 490611, 491007, 490484, 490821,
	# 490859, 490828, 490690, 490552, 490385, 489751, 490128
	"${WORKDIR}/${P}-patchset"
)

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
		-DBUILD_WITH_QT6=ON
		-DBUILD_TESTING=OFF # bug 698192
		-DENABLE_APPSTYLES=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
		-DENABLE_SHOWFOTO=ON # built unconditionally so far, new option since 8.0
		-DENABLE_AKONADICONTACTSUPPORT=$(usex addressbook)
		$(cmake_use_find_package calendar KF6CalendarCore)
		-DENABLE_GEOLOCATION=$(usex geolocation)
		$(cmake_use_find_package gphoto2 Gphoto2)
		$(cmake_use_find_package heif Libheif)
		$(cmake_use_find_package imagemagick ImageMagick)
		$(cmake_use_find_package jpegxl Libjxl)
		$(cmake_use_find_package lensfun LensFun)
		-DENABLE_MYSQLSUPPORT=$(usex mysql)
		-DENABLE_INTERNALMYSQL=$(usex mysql)
		$(cmake_use_find_package panorama KF6ThreadWeaver)
		$(cmake_use_find_package scanner KSaneWidgets6)
		-DENABLE_KFILEMETADATASUPPORT=$(usex semantic-desktop)
		$(cmake_use_find_package spell KF6Sonnet)
		-DENABLE_MEDIAPLAYER=$(usex video)
	)

	ecm_src_configure
}
