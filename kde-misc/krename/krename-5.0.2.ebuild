# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=5.82.0
QTMIN=5.15.5
inherit ecm kde.org

DESCRIPTION="Powerful batch file renamer"
HOMEPAGE="https://apps.kde.org/krename/ https://userbase.kde.org/KRename"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="exif pdf taglib truetype"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	exif? ( media-gfx/exiv2:= )
	pdf? ( app-text/podofo:= )
	taglib? ( media-libs/taglib )
	truetype? ( media-libs/freetype:2 )
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=( "${FILESDIR}/${PN}-5.0.1-no-kjs.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package exif LibExiv2)
		$(cmake_use_find_package pdf PoDoFo)
		$(cmake_use_find_package taglib Taglib)
		$(cmake_use_find_package truetype Freetype)
	)
	ecm_src_configure
}
