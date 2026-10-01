# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="State Chart XML (SCXML) support library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="qml"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui]
	qml? ( ~dev-qt/qtdeclarative-${PV}:6 )
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# may fail with pid-sandbox, or at least musl/hardened+gcc (exact
	# conditions unknown but passes without pid, considering this flaky)
	tst_qstatemachine
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
	)

	qt6-build_src_configure
}
