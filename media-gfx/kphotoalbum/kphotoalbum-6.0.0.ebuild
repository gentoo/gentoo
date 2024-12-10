# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm kde.org

DESCRIPTION="Tool for indexing, searching, and viewing images"
HOMEPAGE="https://www.kphotoalbum.org/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+ FDL-1.2 CC-BY-SA-4.0"
SLOT="0"
IUSE="+map phonon +raw share +vlc"

REQUIRED_USE="|| ( phonon vlc )"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,sql,sqlite,widgets,xml]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	media-gfx/exiv2:=
	media-libs/libjpeg-turbo:=
	map? ( kde-apps/marble:6 )
	phonon? ( >=media-libs/phonon-4.12.0[qt6(+)] )
	raw? ( kde-apps/libkdcraw:6 )
	share? ( >=kde-frameworks/kxmlgui-${KFMIN}:6 )
	vlc? ( media-video/vlc:= )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	media-video/ffmpeg
"

DOCS=( CHANGELOG.{md,old} README.md )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package map Marble)
		$(cmake_use_find_package phonon Phonon4Qt6)
		$(cmake_use_find_package raw KDcrawQt6)
		$(cmake_use_find_package share KF6Purpose)
		$(cmake_use_find_package vlc LIBVLC)
	)

	ecm_src_configure
}
