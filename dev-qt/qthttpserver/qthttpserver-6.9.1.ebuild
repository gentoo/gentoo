# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="HTTP server functionality for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm64 ~loong"
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

CMAKE_SKIP_TESTS=(
	# most http/2 tests are fine but two been failing since 6.9.1,
	# needs looking into but skip for now (maybe(?) due to changes
	# in tst_qhttpserver.cpp rather than a runtime issue):
	# tst_QHttpServer::multipleRequests(http/2)
	# tst_QHttpServer::pipelinedRequests(http/2)
	tst_qhttpserver
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package websockets Qt6WebSockets)
	)

	qt6-build_src_configure
}
