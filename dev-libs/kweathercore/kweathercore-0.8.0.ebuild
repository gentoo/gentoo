# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=5.245.0
QTMIN=6.6.2
inherit ecm kde.org

DESCRIPTION="Library for retrieval of weather information including forecasts and alerts"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi
LICENSE="LGPL-2+"
SLOT="6"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[network]
	>=dev-qt/qtpositioning-${QTMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}"

src_test() {
	local myctestargs=(
		-E "locationquerytest"
	)
	ecm_src_test
}
