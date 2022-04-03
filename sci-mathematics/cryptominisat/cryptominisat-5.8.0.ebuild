# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )

inherit python-single-r1 cmake

DESCRIPTION="Advanced SAT solver with C++ and Python interfaces"
HOMEPAGE="https://github.com/msoos/cryptominisat/"
SRC_URI="https://github.com/msoos/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2 MIT"
IUSE="+python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test"  # tests require many convoluted bundled (git) modules

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-setup.py.in-sysconfig.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DNOBREAKID=ON
		-DNOM4RI=ON
		-DENABLE_PYTHON_INTERFACE=$(usex python)
		-DFORCE_PYTHON3=$(usex python)
		-DENABLE_TESTING=OFF
	)
	cmake_src_configure
}
