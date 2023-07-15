# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=5.99.0
QTMIN=5.15.5
inherit ecm kde.org

DESCRIPTION="Library for retrieval of weather information including forecasts and alerts"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 x86"
fi
LICENSE="LGPL-2+"
SLOT="5"

DEPEND="
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtpositioning-${QTMIN}:5
	>=kde-frameworks/kholidays-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
"
RDEPEND="${DEPEND}"

src_test() {
	local myctestargs=(
		-E "locationquerytest"
	)
	ecm_src_test
}
