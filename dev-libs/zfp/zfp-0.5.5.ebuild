# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#DOCS_BUILDER="sphinx"
#DOCS_DIR="docs/source"
PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit cmake fortran-2 python-single-r1 #docs

DESCRIPTION="Compressed numerical arrays that support high-speed random access"
SRC_URI="https://github.com/LLNL/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="
	https://computing.llnl.gov/projects/zfp
	https://zfp.io
	https://github.com/LLNL/ZFP
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="aligned cfp fasthash examples fortran openmp profile python strided test twoway +utilities" #doc cuda
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="utilities? ( app-admin/chrpath )"

pkg_setup() {
	FORTRAN_NEED_OPENMP=0
	use openmp && FORTRAN_NEED_OPENMP=1
	use fortran && fortran-2_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
		#I can't test for cuda stuff
		#-DZFP_WITH_CUDA=$(usex cuda)
	local mycmakeargs=(
		-DBUILD_CFP=$(usex cfp)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex test)
		-DBUILD_UTILITIES=$(usex utilities)
		-DBUILD_ZFORP=$(usex fortran)
		-DBUILD_ZFPY=$(usex python)
		-DZFP_WITH_ALIGNED_ALLOC=$(usex aligned)
		-DZFP_WITH_BIT_STREAM_STRIDED=$(usex strided)
		-DZFP_WITH_CACHE_FAST_HASH=$(usex fasthash)
		-DZFP_WITH_CACHE_PROFILE=$(usex profile)
		-DZFP_WITH_CACHE_TWOWAY=$(usex twoway)
		-DZFP_WITH_OPENMP=$(usex openmp)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	#docs only available starting from the next release
	#use doc && docs_compile
}

src_install() {
	cmake_src_install
	use python && python_optimize "${D}/$(python_get_sitedir)"
	use test && rm "${BUILD_DIR}/bin/testzfp"
	if use utilities; then
		pushd "${BUILD_DIR}/bin" || die
		dobin zfp
		rm zfp
		popd || die
		chrpath -d "${ED}/usr/bin/zfp" || die
	fi
	if use examples; then
		pushd "${BUILD_DIR}/bin" || die
		exeinto "/usr/libexec/zfp"
		doexe *
		chrpath -d "${ED}"/usr/libexec/zfp/* || die
	fi
}
