# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_QTHELP="false"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Library to determine holidays and other special events for a geographical region"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

COMMON_DEPEND="
	$(add_qt_dep qtdeclarative)
"
DEPEND="${COMMON_DEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kholidays:5
"

src_test() {
	# bug 624214
	mkdir -p "${HOME}/.local/share/kf5/libkholidays" || die
	cp -r "${S}/holidays/plan2" "${HOME}/.local/share/kf5/libkholidays/" || die
	kde5_src_test
}
