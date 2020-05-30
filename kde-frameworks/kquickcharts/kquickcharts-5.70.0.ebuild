# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_EXAMPLES="true"
ECM_QTHELP="false"
ECM_TEST="true"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="QtQuick plugin providing high-performance charts"
HOMEPAGE="https://invent.kde.org/frameworks/kquickcharts"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	examples? (
		>=dev-qt/qtwidgets-${QTMIN}:5
		=kde-frameworks/kdeclarative-${PVCUT}*:5
		=kde-frameworks/kirigami-${PVCUT}*:5
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
	)

	ecm_src_configure
}
