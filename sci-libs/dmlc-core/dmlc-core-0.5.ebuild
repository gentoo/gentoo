# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Common bricks library for building distributed machine learning"
HOMEPAGE="https://github.com/dmlc/dmlc-core"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/dmlc/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/dmlc/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="Apache-2.0"
SLOT="0"

# hdfs needs big java hdfs not yet in portage
# azure not yet in portage
IUSE="cpu_flags_x86_sse2 doc openmp s3 test"
RESTRICT="!test? ( test )"

RDEPEND="s3? ( net-misc/curl[ssl] )"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen[dot] )
	test? ( dev-cpp/gtest )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare

	sed -e '/-O3/d' -e '/check_cxx_compiler_flag("-msse2"/d' \
		-e '/check_cxx.*SSE2/d' \
		-i CMakeLists.txt || die

	# All these hacks below to allow testing
	sed -e 's|-O3||' -e 's|-std=c++11|-std=c++14|' \
		-e "s|-lm|-lm -L\"${BUILD_DIR}\" -ldmlc|g" \
		-i Makefile || die
	sed -e "s|libdmlc.a||g" \
		-e "/^GTEST_LIB=/s|=.*|=/usr/$(get_libdir)|" \
		-e "/^GTEST_INC=/s|=.*|=/usr/include|" \
		-i test/dmlc_test.mk test/unittest/dmlc_unittest.mk || die
	# Don't ever download gtest
	sed -e 's/^if (NOT GTEST_FOUND)$/if (FALSE)/' \
		-i test/unittest/CMakeLists.txt || die
	cat <<-EOF > config.mk
		USE_SSE=$(usex cpu_flags_x86_sse2 1 0)
		WITH_FPIC=1
		USE_OPENMP=$(usex openmp 1 0)
		USE_S3=$(usex s3 1 0)
		BUILD_TEST=$(usex test 1 0)
		DMLC_CFLAGS=${CXXFLAGS}
		DMLC_LDFLAGS=${LDFLAGS}
	EOF
}

src_configure() {
	local mycmakeargs=(
		-DGOOGLE_TEST=$(usex test)
		-DSUPPORT_MSSE2=$(usex cpu_flags_x86_sse2)
		-DUSE_CXX14_IF_AVAILABLE=YES # Newer gtest needs C++14 or later
		-DUSE_S3=$(usex s3)
		-DUSE_OPENMP=$(usex openmp)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && emake doxygen
	use test && emake test
}

src_test() {
	DMLC_UNIT_TEST_LITTLE_ENDIAN=$([[ $(tc-endian) == little ]] && echo 1 || echo 0) \
	LD_LIBRARY_PATH="${BUILD_DIR}" \
		test/unittest/dmlc_unittest || die

	cmake_src_test
}

src_install() {
	cmake_src_install

	if use doc; then
		dodoc -r doc/doxygen/html
		docompress -x /usr/share/doc/${PF}/html
	fi
}
