# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs cmake-utils

DESCRIPTION="Common bricks library for building distributed machine learning."
HOMEPAGE="https://github.com/dmlc/dmlc-core"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/dmlc/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	EGIT_COMMIT="54db57d5d1b2a7b93319053011802888b827a539"
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="${HOMEPAGE}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="0"

# hdfs needs big java hdfs not yet in portage
# azure not yet in portage
IUSE="doc openmp s3 test"
RESTRICT="!test? ( test )"

RDEPEND="net-misc/curl[ssl]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/gtest )
"

PATCHES=( "${FILESDIR}"/${PN}-install-dirs.patch )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake-utils_src_prepare
	# respect user flags (SSE2 does nothing more than adding -msse2)
	# also doc install everything so remove
	sed -e '/-O3/d' \
		-e '/check_cxx.*SSE2/d' \
		-i CMakeLists.txt || die
	# all these hacks below to allow testing
	sed -e 's|-O3||' -e 's|-lm|-lm -L$(LD_LIBRARY_PATH) -ldmlc|g' -i Makefile || die
	sed -e "s|libdmlc.a||g" \
		-i test/dmlc_test.mk test/unittest/dmlc_unittest.mk || die
	cat <<-EOF > config.mk
		USE_SSE=0
		WITH_FPIC=1
		USE_OPENMP=$(use openmp && echo 1 || echo 0)
		USE_S3=$(use s3 && echo 1 || echo 0)
		BUILD_TEST=$(use test && echo 1 || echo 0)
		DMLC_CFLAGS=${CXXFLAGS}
		DMLC_LDFLAGS=${LDFLAGS}
	EOF
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DUSE_S3="$(usex s3)"
		-DUSE_OPENMP="$(usex openmp)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen doc/Doxyfile || die
	fi
}

src_test() {
	tc-export CXX
	export LD_LIBRARY_PATH="${BUILD_DIR}"
	emake test
	test/unittest/dmlc_unittest || die
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/doxygen/html
		docompress -x /usr/share/doc/${PF}/html
	fi
}
