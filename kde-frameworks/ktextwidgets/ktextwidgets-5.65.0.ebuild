# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_DESIGNERPLUGIN="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing an assortment of widgets for displaying and editing text"
LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="speech"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcompletion-${PVCUT}:5
	>=kde-frameworks/kconfig-${PVCUT}:5
	>=kde-frameworks/kconfigwidgets-${PVCUT}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kservice-${PVCUT}:5
	>=kde-frameworks/kwidgetsaddons-${PVCUT}:5
	>=kde-frameworks/kwindowsystem-${PVCUT}:5
	>=kde-frameworks/sonnet-${PVCUT}:5
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package speech Qt5TextToSpeech)
	)

	ecm_src_configure
}
