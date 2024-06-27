# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="true"
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Library to determine holidays and other special events for a geographical region"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND=">=dev-qt/qtdeclarative-${QTMIN}:6"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_test() {
	# bug 624214
	mkdir -p "${HOME}/.local/share/kf6/libkholidays" || die
	cp -r "${S}/holidays/plan2" "${HOME}/.local/share/kf6/libkholidays/" || die
	ecm_src_test
}
