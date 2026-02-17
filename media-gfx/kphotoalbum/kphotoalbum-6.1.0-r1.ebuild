# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCHSET=${P}-backport-qtmultimedia
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm kde.org xdg

DESCRIPTION="Tool for indexing, searching, and viewing images"
HOMEPAGE="https://www.kphotoalbum.org/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz
	https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2+ FDL-1.2 CC-BY-SA-4.0"
SLOT="0"
IUSE="+map +raw share"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,sql,sqlite,widgets,xml]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
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
	raw? ( kde-apps/libkdcraw:6 )
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	media-video/ffmpeg
"
BDEPEND=">=dev-build/cmake-3.30"

DOCS=( CHANGELOG.{md,old} README.md )

PATCHES=( "${WORKDIR}"/${PATCHSET} )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_LIBVLC=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Phonon4Qt6=ON
		$(cmake_use_find_package map Marble)
		$(cmake_use_find_package raw KDcrawQt6)
		$(cmake_use_find_package share KF6Purpose)
	)

	ecm_src_configure
}
