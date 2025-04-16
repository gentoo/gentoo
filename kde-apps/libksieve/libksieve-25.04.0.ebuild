# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_QTHELP="true"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Common PIM libraries"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="speech"

RESTRICT="test"

RDEPEND="
	dev-libs/cyrus-sasl
	>=dev-libs/ktextaddons-1.5.4:6[speech?]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/libkdepim-${PVCUT}:6
	>=kde-apps/pimcommon-${PVCUT}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
"
DEPEND="${RDEPEND}
	>=kde-apps/kimap-${PVCUT}:6
	>=kde-apps/kmailtransport-${PVCUT}:6
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package speech KF6TextEditTextToSpeech)
	)

	ecm_src_configure
}
