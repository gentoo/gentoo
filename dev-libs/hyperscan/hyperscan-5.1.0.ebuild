# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit cmake python-r1

DESCRIPTION="High-performance regular expression matching library"
SRC_URI="https://github.com/intel/hyperscan/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://www.hyperscan.io/ https://github.com/intel/hyperscan"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_ssse3 static-libs"

RDEPEND="
	${PYTHON_DEPS}
	dev-util/ragel
	>=dev-libs/boost-1.57:=
	net-libs/libpcap"

BDEPEND="${RDEPEND}"

REQUIRED_USE="cpu_flags_x86_ssse3
	${PYTHON_REQUIRED_USE}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DBUILD_STATIC_AND_SHARED=$(usex static-libs ON OFF)
	)
	cmake_src_configure
}
