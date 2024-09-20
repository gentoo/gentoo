# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=434e76680c8880efc450056f074f027aca26fd75
ECM_TEST="true"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Powerful batch file renamer"
HOMEPAGE="https://apps.kde.org/krename/ https://userbase.kde.org/KRename"

LICENSE="GPL-2"
SLOT="6"
IUSE="exif office pdf taglib truetype"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	exif? ( media-gfx/exiv2:= )
	office? ( >=kde-frameworks/karchive-${KFMIN}:6 )
	pdf? ( app-text/podofo:= )
	taglib? ( media-libs/taglib:= )
	truetype? ( media-libs/freetype:2 )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package exif LibExiv2)
		$(cmake_use_find_package office KF6Archive)
		$(cmake_use_find_package pdf PoDoFo)
		$(cmake_use_find_package taglib Taglib)
		$(cmake_use_find_package truetype Freetype)
	)
	ecm_src_configure
}
