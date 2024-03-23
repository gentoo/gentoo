# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Hardware sensor access library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm64 ~loong"
fi

IUSE="qml"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[dbus]
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
	)

	qt6-build_src_configure
}
