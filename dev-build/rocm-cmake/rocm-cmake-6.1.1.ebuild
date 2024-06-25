# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/rocm-cmake.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ROCm/rocm-cmake/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm-cmake-rocm-${PV}"
fi

DESCRIPTION="Radeon Open Compute CMake Modules"
HOMEPAGE="https://github.com/ROCm/rocm-cmake"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
RESTRICT="test"

DOCS=( CHANGELOG.md LICENSE README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-license.patch
	"${FILESDIR}"/${PN}-6.1.1-no-rocmchecks-warnings.patch
)

src_prepare() {
	sed -e "/CMAKE_INSTALL_LIBDIR/s:lib:$(get_libdir):" \
		-i "share/rocmcmakebuildtools/cmake/ROCMCreatePackage.cmake" \
		-i "share/rocmcmakebuildtools/cmake/ROCMInstallTargets.cmake" || die
	cmake_src_prepare
}
