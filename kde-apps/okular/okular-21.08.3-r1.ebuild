# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.84.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Universal document viewer based on KDE Frameworks"
HOMEPAGE="https://okular.kde.org https://apps.kde.org/okular/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="activities chm djvu epub +image-backend kwallet markdown mobi +pdf +plucker +postscript qml share speech +tiff"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjs-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpty-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
	media-libs/freetype
	>=media-libs/phonon-4.11.0
	sys-libs/zlib
	activities? ( >=kde-frameworks/kactivities-${KFMIN}:5 )
	chm? (
		dev-libs/chmlib
		dev-libs/libzip:=
		>=kde-frameworks/khtml-${KFMIN}:5
	)
	djvu? ( app-text/djvu )
	epub? ( app-text/ebook-tools )
	image-backend? (
		>=dev-qt/qtgui-${QTMIN}:5[gif,jpeg,png]
		>=kde-apps/libkexiv2-${PVCUT}:5
	)
	kwallet? ( >=kde-frameworks/kwallet-${KFMIN}:5 )
	markdown? ( app-text/discount )
	mobi? ( >=kde-apps/kdegraphics-mobipocket-${PVCUT}:5 )
	pdf? ( app-text/poppler[nss,qt5] )
	plucker? ( virtual/jpeg:0 )
	postscript? ( app-text/libspectre )
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
	tiff? ( media-libs/tiff:0 )
"
RDEPEND="${DEPEND}
	image-backend? ( >=kde-frameworks/kimageformats-${KFMIN}:5 )
	qml? (
		>=dev-qt/qtquickcontrols2-${QTMIN}:5
		>=kde-frameworks/kirigami-${KFMIN}:5
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-20.11.90-tests.patch" # bug 734138
	"${FILESDIR}/${PN}-20.08.2-hide-mobile-app.patch" # avoid same-name entry
	"${FILESDIR}/${PN}-21.08.1-optional-options.patch" # bug 810958
	"${FILESDIR}/${PN}-21.08.3-optional-activities.patch"
)

src_configure() {
	local mycmakeargs=(
		-DOKULAR_UI=$(usex qml "both" "desktop")
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package chm CHM)
		$(cmake_use_find_package chm KF5KHtml)
		$(cmake_use_find_package chm LibZip)
		$(cmake_use_find_package djvu DjVuLibre)
		$(cmake_use_find_package epub EPub)
		$(cmake_use_find_package image-backend KF5KExiv2)
		-DWITH_KWALLET=$(usex kwallet)
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
	# parttest hangs, bug #641728, annotationtoolbartest fails, KDE-Bug #429640
	local myctestargs=(
		-E "(mainshelltest|chmgeneratortest|parttest|annotationtoolbartest)"
	)

	ecm_src_test
}
