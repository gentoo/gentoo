# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Implementation of the WebSocket protocol for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv x86"
fi

IUSE="qml +ssl"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[network,ssl=]
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
	)

	qt6-build_src_configure
}
