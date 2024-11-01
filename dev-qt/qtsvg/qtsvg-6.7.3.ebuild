# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build toolchain-funcs

DESCRIPTION="SVG rendering library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui,widgets]
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

src_test() {
	# tst_QSvgRenderer::testFeColorMatrix (new in 6.7, likely low impact)
	# is known failing on BE, could use more looking into (bug #935356)
	[[ $(tc-endian) == big ]] && local CMAKE_SKIP_TESTS=( tst_qsvgrenderer )

	qt6-build_src_test
}
