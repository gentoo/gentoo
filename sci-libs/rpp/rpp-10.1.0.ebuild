# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}
PYTHON_COMPAT=( python3_{10..15} )

inherit cmake python-any-r1 rocm toolchain-funcs

DESCRIPTION="AMD ROCm Performance Primitives (RPP) high-performance computer vision library"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rpp"
SRC_URI="https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/rpp.tar.gz -> rpp-${PV}.tar.gz"
S="${WORKDIR}/rpp"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_f16c test"
# pkgcheck warning: RequiredUseDefaults
REQUIRED_USE="
	cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_f16c
	${ROCM_REQUIRED_USE}
"
RESTRICT="!test? ( test )"

# half.hpp is included by the installed rppdefs.h
RDEPEND="
	>=dev-libs/half-1.12.0-r1
	dev-util/hip:${SLOT}
	llvm-runtimes/openmp
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( ${PYTHON_DEPS} )"

DOCS=( CHANGELOG.md README.md )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# no asan libs; upstream test suite (~420 MB of data) is only used from ${S} in src_test
	sed -e "s/COMPONENT \(asan\|test\)/COMPONENT \1 EXCLUDE_FROM_ALL/" -i CMakeLists.txt || die
	# builds test programs against an already installed rpp, automagic OpenCV/NIfTI/libsndfile
	cmake_comment_add_subdirectory utilities/test_suite
	use test || cmake_comment_add_subdirectory test
	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DROCM_PATH=/usr
		-DBACKEND=HIP
		# audio augmentations need FFTS (bundled prebuilt libffts.a is gone, FFTS is not packaged)
		-DRPP_AUDIO_SUPPORT=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_FFTS=ON
	)

	cmake_src_configure
}

rpp_qa() {
	local backend=${1} suite=${2} failed
	local dir="${T}/qa/${backend}-${suite}"
	mkdir -p "${dir}" || die
	pushd "${dir}" >/dev/null || die
	# the drivers exit non-zero on QA mismatches (checked below)
	"${EPYTHON}" "${S}/utilities/test_suite/${backend}/run${suite}Tests.py" \
		--qa_mode 1 --batch_size 3 |& tee qa.log
	# the drivers only log build failures and crashes of the test programs
	grep -qi -e "^Traceback" -e "non-zero exit status" qa.log && die "${backend} ${suite}: test programs failed"
	local results=( QA_RESULTS_*/QA_results.txt )
	[[ -f ${results[0]} ]] || die "${backend} ${suite}: no QA results"
	failed=$(grep -h FAILED "${results[@]}")
	# the random boxes come from <random> distributions; libc++ differs from the reference outputs
	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		failed=$(grep -vE "^(coarse|random_erase)_" <<<"${failed}")
	fi
	[[ -z ${failed} ]] || die "${backend} ${suite} QA failures:"$'\n'"${failed}"
	popd >/dev/null || die
}

src_test() {
	check_amdgpu

	# no RPATH: use the library from the build tree, not an installed one
	LD_LIBRARY_PATH="${BUILD_DIR}/$(get_libdir)" cmake_src_test

	# upstream QA drivers build their test programs against an installed rpp
	DESTDIR="${T}/stage" cmake_build install
	local -x ROCM_PATH="${EPREFIX}/usr" CMAKE_PREFIX_PATH="${T}/stage/usr"
	local -x LD_LIBRARY_PATH="${T}/stage/usr/$(get_libdir)"
	local backend
	for backend in HOST HIP; do
		rpp_qa ${backend} Image
		rpp_qa ${backend} Misc
	done
}
