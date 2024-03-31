# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Common PIM libraries"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 arm64 ~x86"
IUSE="speech"

RESTRICT="test"

RDEPEND="
	dev-libs/cyrus-sasl
	dev-libs/ktextaddons:5[speech?]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kpimtextedit-${PVCUT}:5[speech=]
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
"
DEPEND="${RDEPEND}
	>=kde-apps/kimap-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package speech KF5TextEditTextToSpeech)
	)

	ecm_src_configure
}
