# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_EXAMPLES="true"
ECM_QTHELP="false"
ECM_TEST="true"
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="QtQuick plugin providing high-performance charts"
HOMEPAGE="https://invent.kde.org/frameworks/kquickcharts"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64"
IUSE=""

# PVCUT=$(ver_cut 1-2)
# 	examples? (
# 		>=dev-qt/qtwidgets-${QTMIN}:6
# 		=kde-frameworks/kdeclarative-${PVCUT}*:5
# 		=kde-frameworks/kirigami-${PVCUT}*:5
# 	)
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
	)

	ecm_src_configure
}
