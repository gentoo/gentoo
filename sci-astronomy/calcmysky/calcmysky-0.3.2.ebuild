# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multibuild cmake

DESCRIPTION="Simulator of light scattering by planetary atmospheres"
HOMEPAGE="https://github.com/10110111/CalcMySky"
SRC_URI="
	https://github.com/10110111/CalcMySky/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3"
# subslot is soversion
SLOT="0/15"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"

IUSE="qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"

DEPEND="
	dev-cpp/eigen:3
	media-libs/glm
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtopengl:5[-gles2-only]
		dev-qt/qtwidgets:5[-gles2-only]
	)
	qt6? (
		dev-qt/qtbase:6[gui,opengl,widgets,-gles2-only]
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/CalcMySky-${PV}"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DQT_VERSION="${MULTIBUILD_VARIANT/qt/}"
		)

		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	multibuild_foreach_variant cmake_build check
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
