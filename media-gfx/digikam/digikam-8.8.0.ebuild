# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm kde.org toolchain-funcs xdg

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	TARNAME="digiKam-${PV/_/-}"
	if [[ ${PV} =~ beta[0-9]$ ]]; then
		SRC_URI="mirror://kde/unstable/${PN}/${TARNAME}.tar.xz"
	else
		SRC_URI="mirror://kde/stable/${PN}/${PV}/${TARNAME}.tar.xz"
	fi
	KEYWORDS="amd64 ~arm64"
fi

DESCRIPTION="Digital photo management application"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="addressbook calendar geolocation gphoto2 heif +imagemagick jpegxl +lensfun mysql openmp +panorama scanner semantic-desktop spell video"

# bug 366505
RESTRICT="test"

# slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
COMMON_DEPEND="
	dev-libs/expat
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,-gles2-only,gui,mysql?,network,opengl,sql,widgets,X,xml]
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
	>=media-libs/opencv-4.8.0:=[contrib,contribdnn,features2d]
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

# bundled, but unused CMake files: core/libs/dplugins/webservices/o2
CMAKE_QA_COMPAT_SKIP=1

PATCHES=(
	"${FILESDIR}/${PN}-8.4.0-cmake.patch"
	"${FILESDIR}/${PN}-8.3.0-cmake-addressbook.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	ecm_src_prepare
	rm -r project/bundles || die
}

# FIXME: Unbundle libraw (libs/rawengine/libraw)
# TODO: adding IUSE X requires upstreaming WITH_X11 option for libX11,
#       see core/cmake/rules/RulesX11.cmake; only used in core/libs/dimg/filters/icc
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
