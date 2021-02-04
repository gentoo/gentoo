# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.75.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Plugins for the KDE Image Plugin Interface"
HOMEPAGE="https://userbase.kde.org/KIPI https://invent.kde.org/graphics/kipi-plugins"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="flashexport mediawiki +remotestorage"

BDEPEND="sys-devel/gettext"
RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	>=kde-apps/libkipi-${PVCUT}:5=
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	flashexport? ( >=kde-frameworks/karchive-${KFMIN}:5 )
	mediawiki? ( net-libs/libmediawiki:5 )
	remotestorage? ( >=kde-frameworks/kio-${KFMIN}:5 )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5Vkontakte=ON
		$(cmake_use_find_package flashexport KF5Archive)
		$(cmake_use_find_package mediawiki KF5MediaWiki)
		$(cmake_use_find_package remotestorage KF5KIO)
	)

	ecm_src_configure
}
