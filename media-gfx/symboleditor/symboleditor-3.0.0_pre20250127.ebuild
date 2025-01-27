# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=75f3cf6d57ea972a561c5c42a0e464a6aef90cd4
ECM_HANDBOOK="optional"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm kde.org

DESCRIPTION="Application to create libraries of QPainterPath objects with rendering hints"
HOMEPAGE="https://apps.kde.org/symboleditor/
https://userbase.kde.org/SymbolEditor"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"
BDEPEND="sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
	)

	ecm_src_configure
}
