# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Multi-page scanning application supporting image and pdf files"
HOMEPAGE="https://apps.kde.org/skanpage/"

LICENSE="|| ( GPL-2 GPL-3 ) CC0-1.0"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE="ocr"

DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/libksane-${PVCUT}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/purpose-${KFMIN}:5
	media-libs/kquickimageeditor:5
	>=media-libs/ksanecore-${PVCUT}:5
	ocr? (
		app-text/tesseract:=
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
