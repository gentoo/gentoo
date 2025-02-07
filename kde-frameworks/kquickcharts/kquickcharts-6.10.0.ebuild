# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_EXAMPLES="true"
ECM_QTHELP="false"
ECM_TEST="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="QtQuick plugin providing high-performance charts"
HOMEPAGE="https://invent.kde.org/frameworks/kquickcharts"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtshadertools-${QTMIN}:6
	examples? (
		>=dev-qt/qtbase-${QTMIN}:6[widgets]
		=kde-frameworks/kdeclarative-${KDE_CATV}*:6
		=kde-frameworks/kirigami-${KDE_CATV}*:6
	)
"
RDEPEND="${DEPEND}
	examples? ( !${CATEGORY}/${PN}:5[examples(-)] )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
	)

	ecm_src_configure
}
