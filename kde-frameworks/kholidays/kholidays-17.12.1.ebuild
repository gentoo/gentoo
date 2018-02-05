# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_AUTODEPS="false"
KDE_QTHELP="false"
KDE_TEST="true"
QT_MINIMAL="5.9.1"
inherit kde5

DESCRIPTION="Library to determine holidays and other special events for a geographical region"
SRC_URI="mirror://kde/stable/applications/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

COMMON_DEPEND="
	$(add_qt_dep qtcore)
	$(add_qt_dep qtdeclarative)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep extra-cmake-modules '' 5.40.0)
	nls? ( $(add_qt_dep linguist-tools) )
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kf-env-4
	|| ( $(add_frameworks_dep breeze-icons '' 5.40.0) kde-frameworks/oxygen-icons:* )
"

src_test() {
	# bug 624214
	mkdir -p "${HOME}/.local/share/kf5/libkholidays" || die
	cp -r "${S}/holidays/plan2" "${HOME}/.local/share/kf5/libkholidays/" || die
	kde5_src_test
}
