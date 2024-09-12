# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_NONGUI="true"
ECM_QTHELP="true"
ECM_TEST="true"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Library for retrieval of weather information including forecasts and alerts"
HOMEPAGE="https://invent.kde.org/libraries/kweathercore"

LICENSE="LGPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[network]
	>=dev-qt/qtpositioning-${QTMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}"

CMAKE_SKIP_TESTS=(
	locationquerytest
	# bug 906392
	metnoparsertest
)
