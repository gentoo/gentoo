# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Continuous Collision Detection and Physics Library"
HOMEPAGE="https://www.bulletphysics.com/"
SRC_URI="https://github.com/bulletphysics/bullet3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc double-precision examples openmp tbb test threads"

REQUIRED_USE="
	openmp? ( threads )
	tbb? ( threads )
"

RDEPEND="
	virtual/opengl
	media-libs/freeglut
	tbb? ( dev-cpp/tbb )
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${PN}-2.85-soversion.patch )

DOCS=( AUTHORS.txt LICENSE.txt README.md )

# Building / linking of third Party library BussIK does not work out of the box
RESTRICT="test"

S="${WORKDIR}/${PN}3-${PV}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare

	# allow to generate docs
	sed -i -e 's/GENERATE_HTMLHELP.*//g' Doxyfile || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CPU_DEMOS=OFF
		-DBUILD_OPENGL3_DEMOS=OFF
		-DBUILD_BULLET2_DEMOS=OFF
		-DUSE_GRAPHICAL_BENCHMARK=OFF
		-DINSTALL_LIBS=ON
		-DBUILD_BULLET3=ON
		-DBUILD_EXTRAS=OFF
		-DUSE_DOUBLE_PRECISION=$(usex double-precision)
		-DBUILD_UNIT_TESTS=$(usex test)
		-DBULLET2_MULTITHREADING=$(usex threads)
		-DBULLET2_USE_OPEN_MP_MULTITHREADING=$(usex openmp)
		-DBULLET2_USE_TBB_MULTITHREADING=$(usex tbb)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		doxygen || die
		HTML_DOCS+=( html/. )
		DOCS+=( docs/*.pdf )
	fi

	if use examples; then
		# throws QA warnings
		rm examples/ThirdPartyLibs/openvr/*/linux*/libopenvr_api.so || die
		DOCS+=( examples )
	fi
}
