# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KDE_TEST=true
fi
CMAKE_MAKEFILE_GENERATOR="emake"
inherit kde5

DESCRIPTION="Digital photo management application"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="addressbook gphoto2 kipi lensfun marble semantic-desktop mysql scanner video X"

if [[ ${KDE_BUILD_TYPE} != live ]]; then

	MY_PV=${PV/_/-}
	MY_P=${PN}-${MY_PV}

	SRC_BRANCH=stable
	[[ ${PV} =~ beta[0-9]$ ]] && SRC_BRANCH=unstable
	SRC_URI="mirror://kde/${SRC_BRANCH}/digikam/${MY_P}.tar.xz"

	S="${WORKDIR}/${MY_P}/core"

fi

COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_kdeapps_dep libkexiv2)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsql 'mysql?')
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/boost[threads]
	dev-libs/expat
	>=media-gfx/exiv2-0.24:=
	media-libs/jasper
	media-libs/lcms:2
	media-libs/liblqr
	>=media-libs/libpgf-6.12.27
	media-libs/libpng:0=
	>=media-libs/opencv-3.0.0:=
	media-libs/tiff:0
	virtual/jpeg:0
	addressbook? (
		$(add_kdeapps_dep akonadi-contact)
		$(add_kdeapps_dep kcontacts)
	)
	scanner? ( $(add_kdeapps_dep libksane) )
	gphoto2? ( media-libs/libgphoto2:= )
	kipi? ( $(add_kdeapps_dep libkipi '' '16.03.80') )
	lensfun? ( media-libs/lensfun )
	marble? (
		$(add_frameworks_dep kbookmarks)
		$(add_frameworks_dep kitemmodels)
		$(add_kdeapps_dep marble)
	)
	semantic-desktop? ( $(add_frameworks_dep kfilemetadata) )
	mysql? ( virtual/mysql )
	video? ( $(add_qt_dep qtmultimedia 'widgets') )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:3
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/kipi-plugins:5
	!media-gfx/digikam:4
"

RESTRICT=test
# bug 366505

src_prepare() {
	undetect_lib() {
		local _use=${1}
		local _name=${2}
		[[ -z ${_name} ]] && _name=$(echo ${_use} | sed 's/./\U&/g')
		use $_use || \
			sed -i -e "/DETECT_LIB${_name}/d" CMakeLists.txt || die
	}

	undetect_lib kipi
	undetect_lib scanner KSANE

	kde5_src_prepare
}

src_configure() {
	# LQR = only allows to choose between bundled/external
	local mycmakeargs=(
		-DENABLE_OPENCV3=ON
		-DENABLE_AKONADICONTACTSUPPORT=$(usex addressbook)
		-DENABLE_KFILEMETADATASUPPORT=$(usex semantic-desktop)
		-DENABLE_MYSQLSUPPORT=$(usex mysql)
		-DENABLE_MEDIAPLAYER=$(usex video)
		$(cmake-utils_use_find_package gphoto2 Gphoto2)
		$(cmake-utils_use_find_package lensfun LensFun)
		$(cmake-utils_use_find_package marble Marble)
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
