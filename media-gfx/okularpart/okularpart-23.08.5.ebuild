# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="false"
ECM_TEST="forceoptional"
KDE_ORG_NAME="okular"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Universal document viewer kpart based on KDE Frameworks"
HOMEPAGE="https://okular.kde.org https://apps.kde.org/okular/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="djvu epub mobi +pdf +postscript +tiff"

# slot op: Uses Qt5::CorePrivate
DEPEND="
	>=dev-qt/qtcore-${QTMIN}:5=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5[gif(+),jpeg,png]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-apps/libkexiv2-${PVCUT}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpty-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/threadweaver-${KFMIN}:5
	media-libs/freetype
	sys-libs/zlib
	djvu? ( app-text/djvu )
	epub? ( app-text/ebook-tools )
	mobi? ( >=kde-apps/kdegraphics-mobipocket-${PVCUT}:5 )
	pdf? ( >=app-text/poppler-21.10.0[nss,qt5] )
	postscript? ( app-text/libspectre )
	tiff? ( media-libs/tiff:= )
"
RDEPEND="${DEPEND}
	!kde-apps/okular:5
	>=kde-frameworks/kimageformats-${KFMIN}:5
"

PATCHES=(
	"${FILESDIR}/${P}-tests.patch" # bug 734138
	"${FILESDIR}/${P}-only.patch"
	"${FILESDIR}/${P}-crashfix.patch" # KDE-bug 476207
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF # tests are executed for okular:5
		-DCMAKE_DISABLE_FIND_PACKAGE_CHM=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Discount=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_JPEG=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5KHtml=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5Purpose=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5Wallet=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Phonon4Qt5=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5TextToSpeech=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_LibZip=ON
		-DFORCE_NOT_REQUIRED_DEPENDENCIES="KF5DocTools;CHM;KF5KHtml;LibZip;KF5Wallet;DjVuLibre;EPub;KF5KExiv2;Discount;QMobipocket;Poppler;JPEG;LibSpectre;KF5Purpose;Qt5TextToSpeech;TIFF;"
		-DOKULAR_UI="desktop"
		$(cmake_use_find_package djvu DjVuLibre)
		$(cmake_use_find_package epub EPub)
		$(cmake_use_find_package mobi QMobipocket)
		$(cmake_use_find_package pdf Poppler)
		$(cmake_use_find_package postscript LibSpectre)
		$(cmake_use_find_package tiff TIFF)
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install

	rm -r "${ED}"/usr/{include,share} || die
}
