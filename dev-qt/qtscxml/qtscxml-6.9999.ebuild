# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="State Chart XML (SCXML) support library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,network,opengl,widgets]
	~dev-qt/qtdeclarative-${PV}:6
"
DEPEND="${RDEPEND}"

CMAKE_SKIP_TESTS=(
	# may fail with pid-sandbox, or at least musl/hardened+gcc (exact
	# conditions unknown but passes without pid, consider flaky)
	tst_qstatemachine
)
