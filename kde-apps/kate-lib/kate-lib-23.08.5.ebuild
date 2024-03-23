# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="utilities"
KDE_ORG_NAME="kate"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Shared library used by Kate/Kwrite and Kate-Addons"
HOMEPAGE="https://kate-editor.org/ https://apps.kde.org/kate/"

LICENSE="LGPL-2 LGPL-2+ MIT"
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE="activities telemetry"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	activities? ( >=kde-plasma/plasma-activities-${KFMIN}:5 )
	telemetry? ( kde-frameworks/kuserfeedback:5 )
"
RDEPEND="${DEPEND}
	!<kde-apps/kate-22.08.0:5
"

src_prepare() {
	ecm_src_prepare

	# delete colliding kate/kwrite translations
	find po -type f -name "*po" -and ! -name 'kate.po' -delete || die
	rm -rf po/*/docs || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_addons=FALSE
		-DBUILD_kate=FALSE
		-DBUILD_kwrite=FALSE
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5DocTools=ON
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package telemetry KUserFeedback)
	)

	ecm_src_configure
}

src_test() {
	# tests hang
	local myctestargs=(
		-E "(session_manager_test|sessions_action_test)"
	)

	ecm_src_test
}
