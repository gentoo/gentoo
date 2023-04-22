# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="true"
QTMIN=5.15.5
inherit ecm frameworks.kde.org

DESCRIPTION="Library to determine holidays and other special events for a geographical region"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE=""

DEPEND=">=dev-qt/qtdeclarative-${QTMIN}:5"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

src_test() {
	# bug 624214
	mkdir -p "${HOME}/.local/share/kf5/libkholidays" || die
	cp -r "${S}/holidays/plan2" "${HOME}/.local/share/kf5/libkholidays/" || die
	ecm_src_test
}
