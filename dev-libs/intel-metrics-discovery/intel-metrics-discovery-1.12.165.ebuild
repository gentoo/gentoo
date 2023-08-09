# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
MY_PN="${PN/intel-/}"
MY_P="${MY_PN}-${PV}"

inherit cmake

DESCRIPTION="A user mode library that provides access to GPU performance data"
HOMEPAGE="https://github.com/intel/metrics-discovery"
SRC_URI="https://github.com/intel/${MY_PN}/archive/refs/tags/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_P}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"

DEPEND="x11-libs/libdrm"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=( -DLINUX_DISTRO="Gentoo" )
	cmake_src_configure
}
