# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Universal document viewer based on KDE Frameworks"
HOMEPAGE="https://okular.kde.org https://apps.kde.org/okular/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="crypt djvu epub +image-backend markdown mobi +pdf +plucker +postscript qml share speech +tiff"

# slot op: Uses Qt5::CorePrivate
DEPEND="
	>=dev-qt/qtcore-${QTMIN}:5=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-plasma/plasma-activities-${KFMIN}:5
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
	crypt? ( >=kde-frameworks/kwallet-${KFMIN}:5 )
	djvu? ( app-text/djvu )
	epub? ( app-text/ebook-tools )
	image-backend? (
		>=dev-qt/qtgui-${QTMIN}:5[gif(+),jpeg,png]
		>=kde-apps/libkexiv2-${PVCUT}:5
	)
	markdown? ( >=app-text/discount-2.2.7-r1:= )
	mobi? ( >=kde-apps/kdegraphics-mobipocket-${PVCUT}:5 )
	pdf? ( >=app-text/poppler-21.10.0[nss,qt5] )
	plucker? ( media-libs/libjpeg-turbo:= )
	postscript? ( app-text/libspectre )
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
	tiff? ( media-libs/tiff:= )
"
RDEPEND="${DEPEND}
	image-backend? ( >=kde-frameworks/kimageformats-${KFMIN}:5 )
	qml? (
		>=dev-qt/qtquickcontrols2-${QTMIN}:5
		>=kde-frameworks/kirigami-${KFMIN}:5
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-21.11.80-tests.patch" # bug 734138
	"${FILESDIR}/${PN}-20.08.2-hide-mobile-app.patch" # avoid same-name entry
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_CHM=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5KHtml=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_LibZip=ON
		-DFORCE_NOT_REQUIRED_DEPENDENCIES="KF5DocTools;CHM;KF5KHtml;LibZip;KF5Wallet;DjVuLibre;EPub;KF5KExiv2;Discount;QMobipocket;Poppler;JPEG;LibSpectre;KF5Purpose;Qt5TextToSpeech;TIFF;"
		-DOKULAR_UI=$(usex qml "both" "desktop")
		$(cmake_use_find_package crypt KF5Wallet)
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
	# parttest hangs, bug #641728, annotationtoolbartest fails, KDE-Bug #429640
	# signunsignedfieldtest fails, whatever. bug #852749
	local myctestargs=(
		-E "(mainshelltest|chmgeneratortest|parttest|annotationtoolbartest|signunsignedfieldtest)"
	)

	ecm_src_test
}
