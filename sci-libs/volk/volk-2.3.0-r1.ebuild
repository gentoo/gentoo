# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

#https://github.com/gnuradio/volk/issues/383
CMAKE_BUILD_TYPE="Release"
inherit cmake python-single-r1

DESCRIPTION="vector optimized library of kernels"
HOMEPAGE="http://libvolk.org"
SRC_URI="https://github.com/gnuradio/volk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="orc"

RDEPEND="!<net-wireless/gnuradio-3.8
	dev-libs/boost:=
	orc? ( dev-lang/orc )"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep 'dev-python/mako[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]')"

RESTRICT="test"

src_prepare() {
	#https://github.com/gnuradio/volk/issues/382
	#Waiting for confirmation from upstream to push this fix
	#sed -i '/_mm256_zeroupper();/d' kernels/volk/volk_32f_x2_dot_prod_32f.h || die
	mycmakeargs=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ORC=$(usex orc)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
