# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Excel file(*.xlsx) reader/writer library using Qt"
HOMEPAGE="https://github.com/QtExcel/QXlsx"
SRC_URI="https://github.com/QtExcel/QXlsx/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/QXlsx-${PV}/QXlsx"

LICENSE="MIT"
# soversion
SLOT="0/${PV}"
KEYWORDS="amd64 ~ppc ppc64 ~riscv ~x86"

RDEPEND="
	dev-qt/qtbase:6=[gui]
"
DEPEND="${RDEPEND}"

src_prepare() {
	# https://github.com/QtExcel/QXlsx/issues/375#issuecomment-2565987610
	sed -i -e "s/SOVERSION.*/SOVERSION 0.${PV}/" CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6
	)

	cmake_src_configure
}
