# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"
RUBY_OPTIONAL="yes"

inherit cmake ruby-ng

MY_PN="OpenCL-CLHPP"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Khronos OpenCL C++ bindings"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-CLHPP/"
SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Khronos-CLHPP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Tests require CMock (NOT cmocka), which is currently unpackaged
RESTRICT="test"

RDEPEND="virtual/opencl"
DEPEND="${RDEPEND}
	>=dev-util/opencl-headers-${PV}"
BDEPEND="test? ( $(ruby_implementations_depend) )"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	use test && ruby-ng_pkg_setup
}

src_unpack() {
	# suppress ruby-ng export
	default
}

src_prepare() {
	# suppress ruby-ng export
	cmake_src_prepare
}

src_compile() {
	# suppress ruby-ng export
	cmake_src_compile
}

src_install() {
	# suppress ruby-ng export
	cmake_src_install
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
