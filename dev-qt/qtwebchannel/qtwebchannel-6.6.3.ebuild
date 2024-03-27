# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt WebChannel"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~x86"
fi

IUSE="qml"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[concurrent]
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
"
DEPEND="${RDEPEND}"

src_configure() {
	has_version ">=dev-qt/qtdeclarative-${PV}:6" && #913692
		local mycmakeargs=( $(cmake_use_find_package qml Qt6Qml) )

	qt6-build_src_configure
}
