# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm kde.org

DESCRIPTION="Tool for indexing, searching, and viewing images"
HOMEPAGE="https://www.kphotoalbum.org/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2+ FDL-1.2 CC-BY-SA-4.0"
SLOT="5"
IUSE="map phonon +raw share +vlc"

REQUIRED_USE="|| ( phonon vlc )"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[jpeg]
	>=dev-qt/qtsql-${QTMIN}:5[sqlite]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	media-gfx/exiv2:=
	media-libs/libjpeg-turbo:=
	map? ( kde-apps/marble:5 )
	phonon? ( >=media-libs/phonon-4.11.0 )
	raw? ( kde-apps/libkdcraw:5 )
	share? ( >=kde-frameworks/kxmlgui-${KFMIN}:5 )
	vlc? ( media-video/vlc:= )
"
RDEPEND="${DEPEND}
	media-video/ffmpeg
"

DOCS=( CHANGELOG.{md,old} README.md )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_QtAV=ON # bug 758641, last-rited
		$(cmake_use_find_package map Marble)
		$(cmake_use_find_package phonon Phonon4Qt5)
		$(cmake_use_find_package raw KF5KDcraw)
		$(cmake_use_find_package share KF5Purpose)
		$(cmake_use_find_package vlc LIBVLC)
	)

	ecm_src_configure
}
