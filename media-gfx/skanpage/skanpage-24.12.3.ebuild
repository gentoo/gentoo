# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
PVCUT=$(ver_cut 1-3)
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Multi-page scanning application supporting image and pdf files"
HOMEPAGE="https://apps.kde.org/skanpage/"

LICENSE="|| ( GPL-2 GPL-3 ) CC0-1.0"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="ocr"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[pdfium]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/purpose-${KFMIN}:6
	media-libs/kquickimageeditor:6
	>=media-libs/ksanecore-${PVCUT}:6
	ocr? (
		>=app-text/tesseract-5:=
		media-libs/leptonica:=
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package ocr Tesseract)
		$(cmake_use_find_package ocr Leptonica)
	)
	ecm_src_configure
}
