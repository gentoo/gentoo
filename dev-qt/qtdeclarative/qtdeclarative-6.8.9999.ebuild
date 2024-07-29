# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

# behaves very badly when qtdeclarative is not already installed, also
# other more minor issues (installs junk, sandbox/offscreen issues)
QT6_RESTRICT_TESTS=1

inherit python-any-r1 qt6-build

DESCRIPTION="Qt Declarative (Quick 2)"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

IUSE="accessibility +jit +network opengl qmlls +sql +ssl svg vulkan +widgets"

RDEPEND="
	~dev-qt/qtbase-${PV}:6[accessibility=,gui,network=,opengl=,sql?,ssl?,vulkan=,widgets=]
	qmlls? ( ~dev-qt/qtlanguageserver-${PV}:6 )
	svg? ( ~dev-qt/qtsvg-${PV}:6 )
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="
	${PYTHON_DEPS}
	~dev-qt/qtshadertools-${PV}:6
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package qmlls Qt6LanguageServerPrivate)
		$(cmake_use_find_package sql Qt6Sql)
		$(cmake_use_find_package svg Qt6Svg)
		$(qt_feature jit qml_jit)
		$(qt_feature network qml_network)
		$(qt_feature ssl qml_ssl)
	)

	qt6-build_src_configure
}
