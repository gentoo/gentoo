# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Chart component library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

IUSE="gles2-only qml"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gles2-only=,gui,opengl,widgets]
	qml? ( ~dev-qt/qtdeclarative-${PV}:6[opengl] )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qml Qt6Qml)
	)

	qt6-build_src_configure
}
