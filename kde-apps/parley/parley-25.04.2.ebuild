# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_HANDBOOK_DIR="docs"
PVCUT=$(ver_cut 1-3)
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org optfeature xdg

DESCRIPTION="Vocabulary trainer to help you memorize things"
HOMEPAGE="https://apps.kde.org/parley/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="amd64 arm64 ~x86"
IUSE="webengine"

DEPEND="
	app-i18n/translate-shell
	dev-libs/libxml2:2=
	dev-libs/libxslt
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,dbus,gui,widgets]
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-apps/libkeduvocdocument-${PVCUT}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6[widgets] )
"
RDEPEND="${DEPEND}
	>=kde-apps/kdeedu-data-${PVCUT}:*
"

src_prepare() {
	ecm_src_prepare
	cmake_comment_add_subdirectory plugins
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_BROWSERINTEGRATION=$(usex webengine)
	)

	ecm_src_configure
}

pkg_postinst() {
	optfeature "online access to translations" app-i18n/translate-shell
	xdg_pkg_postinst
}
