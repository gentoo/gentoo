# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt module containing the unsupported Qt 5 APIs"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="icu qml"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,icu=,network,xml]
	icu? ( dev-libs/icu:= )
	qml? (
		~dev-qt/qtdeclarative-${PV}:6
		~dev-qt/qtshadertools-${PV}:6
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Quick)
	)

	qt6-build_src_configure
}

src_test() {
	# tst_qxmlinputsource sometimes hang without -j1
	qt6-build_src_test -j1
}
