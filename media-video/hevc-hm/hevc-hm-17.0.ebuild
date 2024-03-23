# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="HEVC HM reference software"
HOMEPAGE="https://hevc.hhi.fraunhofer.de/"
SRC_URI="https://vcgit.hhi.fraunhofer.de/jvet/HM/-/archive/HM-${PV}/HM-HM-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

S="${WORKDIR}/HM-HM-${PV}"

src_prepare() {
	sed -i 's/add_compile_options( "-msse4.1" )//g' CMakeLists.txt || die
	sed -i 's/list( APPEND _bb_warning_options "-Werror" )//g' \
		cmake/CMakeBuild/cmake/modules/BBuildEnv.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHIGH_BITDEPTH=ON
	)
	cmake_src_configure
}

src_install() {
	newbin "${S}/bin/MCTSExtractorStaticp" "MCTSExtractorStatic"
	newbin "${S}/bin/parcatStaticp" "parcatStatic"
	newbin "${S}/bin/SEIRemovalAppStaticp" "SEIRemovalAppStatic"
	newbin "${S}/bin/TAppDecoderAnalyserStaticp" "TAppDecoderAnalyserStatic"
	newbin "${S}/bin/TAppDecoderStaticp" "TAppDecoderStatic"
	newbin "${S}/bin/TAppEncoderStaticp" "TAppEncoderStatic"
	dodoc "${S}/doc/software-manual.pdf"
}
