# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
LLVM_COMPAT=( 18 )
ROCM_VERSION=${PV}

inherit cmake prefix python-any-r1 rocm llvm-r1

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm/roctracer"
SRC_URI="https://github.com/ROCm/roctracer/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/roctracer-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-libs/rocr-runtime
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep '
	dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}"/roctracer-5.7.1-with-tests.patch
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare

	hprefixify script/*.py
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-5.3.3-rocm-path.patch)

	# Install libs directly into /usr/lib64
	sed -e 's:${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}:${CMAKE_INSTALL_LIBDIR}:g' \
		-i src/CMakeLists.txt plugin/file/CMakeLists.txt || die

	# Remove all install commands for tests
	sed -E '/^ *install\(.+/d' -i test/CMakeLists.txt || die

	# Fix search path for HIP cmake
	sed -e "s,\${ROCM_PATH}/lib/cmake,/usr/$(get_libdir)/cmake,g" -i test/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake/hip"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DWITH_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(
		-DHIP_ROOT_DIR="${EPREFIX}/usr"
		-DHIP_CLANG_INSTALL_DIR="$(get_llvm_prefix)/bin"
		-DGPU_TARGETS="$(get_amdgpu_flags)"
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	# if LD_LIBRARY_PATH not set, dlopen cannot find correct lib
	LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir):${LD_LIBRARY_PATH}" bash run.sh || die
}

src_install() {
	cmake_src_install

	# remove unneeded copy
	rm -r "${ED}/usr/share/doc/${PF}-asan" || die
}
