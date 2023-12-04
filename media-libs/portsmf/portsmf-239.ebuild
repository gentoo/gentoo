# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The Tenacity fork of PortSMF, a Standard MIDI File library"
HOMEPAGE="https://codeberg.org/tenacityteam/portsmf"
SRC_URI="
	https://codeberg.org/tenacityteam/portsmf/archive/${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}"
LICENSE="MIT"
SLOT="0/1"  # SOVERSION in CMakeLists.txt / SONAME suffix
KEYWORDS="amd64 ~arm64 ~riscv"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}"-239-revert-extern-to-static-change.patch
	"${FILESDIR}/${PN}"-239-set-correct-cmake-project-ver.patch
	"${FILESDIR}/${PN}"-239-set-correct-pkg-config-ver.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test on off)
		## This is "Build example applications" according to upstream
		#-DBUILD_APPS=$(usex examples on off)
		# The above requires a non-existent PortMidiConfig.cmake.
	)
	cmake_src_configure
}

src_test() {
	# Remove this function when bumping. Upstream HEAD has CTest.
	cd "${BUILD_DIR}"/test || die
	./test </dev/null || die
}
