# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simulator of light scattering by planetary atmospheres"
HOMEPAGE="https://github.com/10110111/CalcMySky"
SRC_URI="
	https://github.com/10110111/CalcMySky/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/CalcMySky-${PV}"

LICENSE="GPL-3"
# subslot is soversion
SLOT="0/15"
KEYWORDS="amd64 ~ppc ~riscv ~x86"

DEPEND="
	dev-cpp/eigen:3
	dev-qt/qtbase:6[gui,opengl,widgets,-gles2-only]
	media-libs/glm
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION=6
	)

	cmake_src_configure
}
