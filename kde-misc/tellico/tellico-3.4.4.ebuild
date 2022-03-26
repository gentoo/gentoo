# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Collection manager based on KDE Frameworks"
HOMEPAGE="https://tellico-project.org/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="https://tellico-project.org/files/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~x86"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="5"
IUSE="bibtex cddb discid pdf scanner semantic-desktop taglib v4l xmp yaz"

# tests need network access
RESTRICT="test"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	dev-qt/qtcharts:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/karchive:5
	kde-frameworks/kcodecs:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kcrash:5
	kde-frameworks/kguiaddons:5
	kde-frameworks/kiconthemes:5
	kde-frameworks/kitemmodels:5
	kde-frameworks/ki18n:5
	kde-frameworks/kjobwidgets:5
	kde-frameworks/kio:5
	kde-frameworks/knewstuff:5
	kde-frameworks/kparts:5
	kde-frameworks/kservice:5
	kde-frameworks/ktextwidgets:5
	kde-frameworks/kwallet:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kwindowsystem:5
	kde-frameworks/kxmlgui:5
	kde-frameworks/solid:5
	kde-frameworks/sonnet:5
	bibtex? ( >=dev-perl/Text-BibTeX-0.780.0-r1 )
	cddb? ( kde-apps/libkcddb:5 )
	discid? ( dev-libs/libcdio:= )
	pdf? ( app-text/poppler[qt5] )
	scanner? ( kde-apps/libksane:5 )
	semantic-desktop? ( kde-frameworks/kfilemetadata:5 )
	taglib? ( >=media-libs/taglib-1.5 )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	xmp? ( >=media-libs/exempi-2 )
	yaz? ( >=dev-libs/yaz-2:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Csv=ON
		-DENABLE_BTPARSE=$(usex bibtex)
		$(cmake_use_find_package cddb KF5Cddb)
		$(cmake_use_find_package discid CDIO)
		$(cmake_use_find_package pdf Poppler)
		$(cmake_use_find_package scanner KF5Sane)
		$(cmake_use_find_package semantic-desktop KF5FileMetaData)
		$(cmake_use_find_package taglib Taglib)
		-DENABLE_WEBCAM=$(usex v4l)
		$(cmake_use_find_package xmp Exempi)
		$(cmake_use_find_package yaz Yaz)
	)

	ecm_src_configure
}
