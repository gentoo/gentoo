# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm kde.org

DESCRIPTION="Collection manager based on KDE Frameworks"
HOMEPAGE="https://tellico-project.org/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="https://tellico-project.org/files/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="bibtex cddb discid pdf scanner semantic-desktop taglib v4l xmp yaz"

# tests need network access
RESTRICT="test"

DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtcharts-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	bibtex? ( >=dev-perl/Text-BibTeX-0.780.0-r1 )
	cddb? ( kde-apps/libkcddb:6 )
	discid? ( dev-libs/libcdio:= )
	pdf? ( app-text/poppler[qt6] )
	scanner? ( kde-apps/libksane:6 )
	semantic-desktop? ( >=kde-frameworks/kfilemetadata-${KFMIN}:6 )
	taglib? ( >=media-libs/taglib-1.5:= )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	xmp? ( >=media-libs/exempi-2:= )
	yaz? ( >=dev-libs/yaz-2:0= )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Csv=ON
		-DENABLE_BTPARSE=$(usex bibtex)
		$(cmake_use_find_package cddb KCddb6)
		$(cmake_use_find_package discid CDIO)
		$(cmake_use_find_package pdf Poppler)
		$(cmake_use_find_package scanner KSaneWidgets6)
		$(cmake_use_find_package semantic-desktop KF6FileMetaData)
		$(cmake_use_find_package taglib Taglib)
		-DENABLE_WEBCAM=$(usex v4l)
		$(cmake_use_find_package xmp Exempi)
		$(cmake_use_find_package yaz Yaz)
	)

	ecm_src_configure
}
