# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="HTTP server functionality for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~x86"
fi

IUSE="+ssl websockets"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[network,ssl=]
	websockets? ( ~dev-qt/qtwebsockets-${PV}:6 )
"
DEPEND="
	${RDEPEND}
	test? ( ~dev-qt/qtbase-${PV}:6[concurrent] )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package websockets Qt6WebSockets)
	)

	qt6-build_src_configure
}
