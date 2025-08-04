# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing an assortment of widgets for displaying and editing text"

LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="speech"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	=kde-frameworks/kcompletion-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
	=kde-frameworks/sonnet-${KDE_CATV}*:6
	speech? ( >=dev-qt/qtspeech-${QTMIN}:6 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_TEXT_TO_SPEECH=$(usex speech)
	)

	ecm_src_configure
}
