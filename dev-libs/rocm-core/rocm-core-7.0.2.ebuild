# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library that provides ROCm release version and install path information"
HOMEPAGE="https://github.com/ROCm/rocm-systems/tree/develop/projects/rocm-core"
SRC_URI="https://github.com/ROCm/rocm-core/archive/refs/tags/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rocm-core-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

src_configure() {
	local mycmakeargs=( -DROCM_VERSION=${PV} )
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# too broad for standard directory
	rm "${ED}"/usr/.info/version || die
}

RDEPEND="!<dev-util/hip-7.0"
