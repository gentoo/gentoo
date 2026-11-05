# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qt6-build

DESCRIPTION="Qt APIs and Tools for Graphics Pipelines"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

RDEPEND="
	~dev-qt/qtbase-${PV}:6[gui]
"
DEPEND="${RDEPEND}"

src_configure() {
	# -Werror=odr violations between mismatching spirv.hpp (bug #972694)
	filter-lto

	qt6-build_src_configure
}
