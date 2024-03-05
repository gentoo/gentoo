# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm kde.org toolchain-funcs

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	if [[ ${PV} =~ beta[0-9]$ ]]; then
		SRC_URI="mirror://kde/unstable/${PN}/"
	else
		SRC_URI="mirror://kde/stable/${PN}/${PV}/"
	fi
	SRC_URI+="digiKam-${PV/_/-}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

DESCRIPTION="Digital photo management application"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2"
SLOT="5"
IUSE="addressbook calendar gphoto2 heif +imagemagick +lensfun marble mysql opengl openmp +panorama scanner semantic-desktop spell"

# bug 366505
RESTRICT="test"

COMMON_DEPEND="
	dev-libs/expat
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[-gles2-only]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtnetworkauth-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[mysql?]
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
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
	>=media-gfx/exiv2-0.27.1:=[xmp]
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/liblqr
	media-libs/libpng:=
	>=media-libs/opencv-3.3.0:=[contrib,contribdnn,features2d]
	media-libs/tiff:=
	x11-libs/libX11
	addressbook? (
		>=kde-apps/akonadi-contacts-19.04.3:5
		>=kde-frameworks/kcontacts-${KFMIN}:5
	)
	calendar? ( >=kde-frameworks/kcalendarcore-${KFMIN}:5 )
	gphoto2? ( media-libs/libgphoto2:= )
	heif? (
		media-libs/libheif:=
		media-libs/x265:=
	)
	imagemagick? ( media-gfx/imagemagick:= )
	lensfun? ( media-libs/lensfun )
	marble? (
		>=dev-qt/qtconcurrent-${QTMIN}:5
		>=kde-apps/marble-19.04.3:5
		>=kde-frameworks/kbookmarks-${KFMIN}:5
	)
	opengl? (
		>=dev-qt/qtopengl-${QTMIN}:5
		virtual/opengl
	)
	panorama? ( >=kde-frameworks/threadweaver-${KFMIN}:5 )
	scanner? ( >=kde-apps/libksane-19.04.3:5 )
	semantic-desktop? ( >=kde-frameworks/kfilemetadata-${KFMIN}:5 )
	spell? ( >=kde-frameworks/sonnet-${KFMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:3
	dev-libs/boost
	addressbook? ( >=kde-apps/akonadi-19.04.3:5 )
"
RDEPEND="${COMMON_DEPEND}
	media-libs/exiftool
	mysql? ( virtual/mysql[server(+)] )
	panorama? ( media-gfx/hugin )
"
BDEPEND="
	sys-devel/gettext
	panorama? (
		app-alternatives/yacc
		app-alternatives/lex
	)
"

PATCHES=( "${FILESDIR}"/${P}-{cmake,akonadi}.patch )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	ecm_pkg_pretend
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	ecm_pkg_setup
}

src_prepare() {
	ecm_src_prepare
	if has_version ">=kde-apps/akonadi-contacts-23.08.0"; then
		sed -e "/KF5[:]*Akonadi/s/KF5/KPim5/" \
			-i core/CMakeLists.txt \
				core/utilities/extrasupport/CMakeLists.txt \
				core/utilities/extrasupport/addressbook/CMakeLists.txt \
				core/app/DigikamCoreTarget.cmake \
				core/cmake/rules/RulesKDEFramework.cmake || die
	fi
}

# FIXME: Unbundle libraw (libs/rawengine/libraw)
src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_CCACHE=OFF
		-DBUILD_WITH_QT6=OFF # KF6 not stable upstream yet
		-DBUILD_TESTING=OFF # bug 698192
		-DENABLE_APPSTYLES=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
		-DENABLE_MEDIAPLAYER=OFF # bug 758641; bundled as of 8.0, KDE-bug 448681
		-DENABLE_SHOWFOTO=ON # built unconditionally so far, new option since 8.0
		-DENABLE_QWEBENGINE=ON
		-DENABLE_AKONADICONTACTSUPPORT=$(usex addressbook)
		$(cmake_use_find_package calendar KF5CalendarCore)
		$(cmake_use_find_package gphoto2 Gphoto2)
		$(cmake_use_find_package heif Libheif)
		$(cmake_use_find_package imagemagick ImageMagick)
		$(cmake_use_find_package lensfun LensFun)
		$(cmake_use_find_package marble Marble)
		-DENABLE_MYSQLSUPPORT=$(usex mysql)
		-DENABLE_INTERNALMYSQL=$(usex mysql)
		$(cmake_use_find_package opengl OpenGL)
		$(cmake_use_find_package panorama KF5ThreadWeaver)
		$(cmake_use_find_package scanner KF5Sane)
		$(cmake_use_find_package spell KF5Sonnet)
		-DENABLE_KFILEMETADATASUPPORT=$(usex semantic-desktop)
	)

	ecm_src_configure
}
