# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.6.0
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing data models to help with tasks such as sorting and filtering"

LICENSE="LGPL-2+"
KEYWORDS="~amd64"
IUSE="qml"

RDEPEND="
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[widgets] )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
	)
	ecm_src_configure
}

src_test() {
	LC_NUMERIC="C" ecm_src_test # bug 708820
}
