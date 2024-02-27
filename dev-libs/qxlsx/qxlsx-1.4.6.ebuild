# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multibuild cmake

DESCRIPTION="Excel file(*.xlsx) reader/writer library using Qt"

HOMEPAGE="https://github.com/QtExcel/QXlsx"
SRC_URI="https://github.com/QtExcel/QXlsx/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
# soversion
SLOT="0/0.1.4.4"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"

IUSE="qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5=
	)
	qt6? (
		dev-qt/qtbase:6=[gui]
	)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/QXlsx-${PV}/QXlsx"

PATCHES=(
	"${FILESDIR}/qxlsx-1.4.6-headers.patch"
)

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DQT_VERSION_MAJOR="${MULTIBUILD_VARIANT/qt/}"
		)

		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
