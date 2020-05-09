# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework providing data models to help with tasks such as sorting and filtering"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="qml"

RDEPEND="
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:5 )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtwidgets-${QTMIN}:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt5Qml)
	)
	ecm_src_configure
}

src_test() {
	LC_NUMERIC="C" ecm_src_test # bug 708820
}
