# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.63.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Universal document viewer based on KDE Frameworks"
HOMEPAGE="https://okular.kde.org https://kde.org/applications/office/org.kde.okular"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="chm crypt djvu epub +image-backend markdown mobi mobile +pdf plucker +postscript share speech +tiff"

DEPEND="
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjs-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpty-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	media-libs/freetype
	media-libs/phonon[qt5(+)]
	sys-libs/zlib
	chm? (
		>=kde-frameworks/khtml-${KFMIN}:5
		dev-libs/chmlib
	)
	crypt? ( app-crypt/qca:2[qt5(+)] )
	djvu? ( app-text/djvu )
	epub? ( app-text/ebook-tools )
	image-backend? (
		>=kde-apps/libkexiv2-${PVCUT}:5
		>=dev-qt/qtgui-${QTMIN}:5[gif,jpeg,png]
	)
	markdown? ( app-text/discount )
	mobi? ( >=kde-apps/kdegraphics-mobipocket-${PVCUT}:5 )
	pdf? ( app-text/poppler[qt5] )
	plucker? ( virtual/jpeg:0 )
	postscript? ( app-text/libspectre )
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
	tiff? ( media-libs/tiff:0 )
"
RDEPEND="${DEPEND}
	image-backend? ( >=kde-frameworks/kimageformats-${KFMIN}:5 )
	mobile? (
		>=kde-frameworks/kirigami-${KFMIN}:5
		>=dev-qt/qtquickcontrols-${QTMIN}:5
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-18.08.0-tests.patch"
	"${FILESDIR}/${PN}-18.12.0-tests.patch"
)

src_prepare() {
	ecm_src_prepare
	use mobile || cmake_comment_add_subdirectory mobile
	use test || cmake_comment_add_subdirectory conf/autotests
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package chm CHM)
		$(cmake_use_find_package crypt Qca-qt5)
		$(cmake_use_find_package djvu DjVuLibre)
		$(cmake_use_find_package epub EPub)
		$(cmake_use_find_package image-backend KF5KExiv2)
		$(cmake_use_find_package markdown Discount)
		$(cmake_use_find_package mobi QMobipocket)
		$(cmake_use_find_package pdf Poppler)
		$(cmake_use_find_package plucker JPEG)
		$(cmake_use_find_package postscript LibSpectre)
		$(cmake_use_find_package share KF5Purpose)
		$(cmake_use_find_package speech Qt5TextToSpeech)
		$(cmake_use_find_package tiff TIFF)
	)

	ecm_src_configure
}

src_test() {
	# mainshelltest hangs, chmgeneratortest fails, bug #603116
	# parttest hangs, bug #641728
	local myctestargs=(
		-E "(mainshelltest|chmgeneratortest|parttest)"
	)

	ecm_src_test
}
