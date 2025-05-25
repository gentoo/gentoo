# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

# Check this on updates
LLVM_COMPAT=( {17..18} )

inherit cmake cuda flag-o-matic llvm-r1 toolchain-funcs python-single-r1

DESCRIPTION="Advanced shading language for production GI renderers"
HOMEPAGE="https://www.imageworks.com/technology/opensource https://github.com/AcademySoftwareFoundation/OpenShadingLanguage"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/OpenShadingLanguage.git"
else
	# If a development release, please don't keyword!
	SRC_URI="https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64"
	S="${WORKDIR}/OpenShadingLanguage-${PV}"
fi

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)" # based on SONAME

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( "${X86_CPU_FEATURES[@]/#/cpu_flags_x86_}" )

IUSE="debug doc gui libcxx nofma optix partio test ${CPU_FEATURES[*]%:*} python"

RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# TODO optix
RDEPEND="
	dev-libs/boost:=
	dev-libs/pugixml
	>=media-libs/openimageio-2.4:=
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
			media-libs/openimageio[python,${PYTHON_SINGLE_USEDEP}]
		')
	)
	partio? ( media-libs/partio )
	gui? (
		dev-qt/qtbase:6[gui,widgets,opengl]
	)
"

DEPEND="${RDEPEND}
	dev-util/patchelf
	>=media-libs/openexr-3
	sys-libs/zlib
	test? (
		media-fonts/droid
		optix? ( dev-libs/optix )
	)
"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-boost-config.patch"
	"${FILESDIR}/${PN}-oslfile.patch"
	"${FILESDIR}/${PN}-include-cstdint.patch"
)

pkg_setup() {
	llvm-r1_pkg_setup

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if use test && use optix; then
		cuda_src_prepare
		cuda_add_sandbox -w
	fi

	sed -e "/^install.*llvm_macros.cmake.*cmake/d" -i CMakeLists.txt || die
	sed -e "/install_targets ( libtestshade )/d" -i src/testshade/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/875836
	# https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/issues/1810
	filter-lto

	# pick the highest we support
	local mysimd=()
	if use cpu_flags_x86_avx512f; then
		mysimd+=( avx512f )
	elif use cpu_flags_x86_avx2 ; then
		mysimd+=( avx2 )
		if use cpu_flags_x86_f16c ; then
			mysimd+=( f16c )
		fi
	elif use cpu_flags_x86_avx ; then
		mysimd+=( avx )
	elif use cpu_flags_x86_sse4_2 ; then
		mysimd+=( sse4.2 )
	elif use cpu_flags_x86_sse4_1 ; then
		mysimd+=( sse4.1 )
	elif use cpu_flags_x86_ssse3 ; then
		mysimd+=( ssse3 )
	elif use cpu_flags_x86_sse3 ; then
		mysimd+=( sse3 )
	elif use cpu_flags_x86_sse2 ; then
		mysimd+=( sse2 )
	fi

	local mybatched=()
	if use cpu_flags_x86_avx512f || use cpu_flags_x86_avx2 ; then
		if use cpu_flags_x86_avx512f ; then
			if use nofma; then
				mybatched+=(
					"b8_AVX512_noFMA"
					"b16_AVX512_noFMA"
				)
			fi
			mybatched+=(
				"b8_AVX512"
				"b16_AVX512"
			)
		fi
		if use cpu_flags_x86_avx2 ; then
			if use nofma; then
				mybatched+=(
					"b8_AVX2_noFMA"
				)
			fi
			mybatched+=(
				"b8_AVX2"
			)
		fi
	fi
	if use cpu_flags_x86_avx ; then
		mybatched+=(
			"b8_AVX"
		)
	fi

	# If no CPU SIMDs were used, completely disable them
	[[ -z "${mysimd[*]}" ]] && mysimd=("0")
	[[ -z "${mybatched[*]}" ]] && mybatched=("0")

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	# Even if there are no SIMD features selected, it seems like the code will turn on NEON support if it is available.
	use arm64 && append-flags -flax-vector-conversions

	local gcc
	gcc="$(tc-getCC)"

	local mycmakeargs=(
		-DCMAKE_POLICY_DEFAULT_CMP0146="OLD" # BUG FindCUDA

		# std::tuple_size_v is c++17
		-DCMAKE_CXX_STANDARD="17"

		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DINSTALL_DOCS="$(usex doc)"
		-DUSE_CCACHE="no"
		-DLLVM_STATIC="no"
		-DOSL_BUILD_TESTS="$(usex test)"
		-DSTOP_ON_WARNING="no"
		-DUSE_PARTIO="$(usex partio)"
		-DUSE_PYTHON="$(usex python)"
		-DUSE_SIMD="$(IFS=","; echo "${mysimd[*]}")"
		-DUSE_BATCHED="$(IFS=","; echo "${mybatched[*]}")"
		-DUSE_LIBCPLUSPLUS="$(usex libcxx)"
		-DUSE_QT="$(usex gui)"

		-DOpenImageIO_ROOT="${EPREFIX}/usr"
	)

	if use debug; then
		mycmakeargs+=(
			-DVEC_REPORT="yes"
		)
	fi

	if use partio; then
		mycmakeargs+=(
			-Dpartio_DIR="${EPREFIX}/usr"
		)
	fi

	if use python; then
		mycmakeargs+=(
			"-DPYTHON_VERSION=${EPYTHON#python}"
			"-DPYTHON_SITE_DIR=$(python_get_sitedir)"
		)
	fi

	if use test; then
		if use optix; then
			mycmakeargs+=(
				-DOSL_USE_OPTIX="yes"
				-DOptiX_FIND_QUIETLY="no"
				-DCUDA_FIND_QUIETLY="no"

				-DOPTIXHOME="${EPREFIX}/opt/optix"
				-DCUDA_TOOLKIT_ROOT_DIR="${CUDA_PATH:-${ESYSROOT}/opt/cuda}"

				-DCUDA_NVCC_FLAGS="--compiler-bindir;$(cuda_gccdir)"
				-DOSL_EXTRA_NVCC_ARGS="--compiler-bindir;$(cuda_gccdir)"
				-DCUDA_VERBOSE_BUILD="yes"
			)
		fi
	fi

	cmake_src_configure
}

src_test() {
	# A bunch of tests only work when installed.
	# So install them into the temp directory now.
	DESTDIR="${T}" cmake_build install

	ln -s "${CMAKE_USE_DIR}/src/cmake/" "${BUILD_DIR}/src/cmake" || die

	if use optix; then
		cp \
			"${BUILD_DIR}/src/liboslexec/shadeops_cuda.ptx" \
			"${BUILD_DIR}/src/testrender/"{optix_raytracer,quad,rend_lib_testrender,sphere,wrapper}".ptx" \
			"${BUILD_DIR}/src/testshade/"{optix_grid_renderer,rend_lib_testshade}".ptx" \
			"${BUILD_DIR}/bin/" || die

		# NOTE this should go to cuda eclass
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia0
		addwrite /dev/nvidia-uvm
		addwrite /dev/nvidia-caps
		addwrite "/dev/char/"
	fi

	CMAKE_SKIP_TESTS=(
		"-broken$"
		"^render"

		# broken with in-tree <=dev-libs/optix-7.5.0 and out of date
		"^example-cuda$"

		# outright fail
		"^testoptix.optix.opt$"
		"^testoptix-noise.optix.opt$"
		"^testoptix-reparam.optix.opt$"
		"^transform-reg.regress.batched.opt$"
		"^spline-reg.regress.batched.opt$"
		"^texture3d-opts-reg.regress.batched.opt$"

		# doesn't handle parameters
		"^osl-imageio$"
		"^osl-imageio.opt$"
		"^osl-imageio.opt.rs_bitcode$"
	)

	if use optix; then
		CMAKE_SKIP_TESTS+=(
			"^color2.optix$"
			"^color4.optix(|.opt|.fused)$"
			"^vector2.optix$"
			"^vector4.optix$"
		)
	fi

	myctestargs=(
		# src/build-scripts/ci-test.bash
		'--force-new-ctest-process'
	)

	local -x DEBUG CXXFLAGS LD_LIBRARY_PATH DIR OSL_DIR OSL_SOURCE_DIR PYTHONPATH
	DEBUG=1 # doubles the floating point tolerance so we avoid FMA related issues
	CXXFLAGS="-I${T}/usr/include"
	LD_LIBRARY_PATH="${T}/usr/$(get_libdir)"
	OSL_DIR="${T}/usr/$(get_libdir)/cmake/OSL"
	OSL_SOURCE_DIR="${S}"

	if use python; then
		PYTHONPATH="${BUILD_DIR}/lib/python/site-packages"
	fi

	cmake_src_test

	einfo ""
	einfo "testing render tests in isolation"
	einfo ""

	CMAKE_SKIP_TESTS=(
		"^render-background$"
		"^render-mx-furnace-sheen$"
		"^render-mx-burley-diffuse$"
		"^render-mx-conductor$"
		"^render-microfacet$"
		"^render-veachmis$"
		"^render-ward$"
		"^render-raytypes.opt$"
		"^render-raytypes.opt.rs_bitcode$"
	)

	myctestargs=(
		# src/build-scripts/ci-test.bash
		'--force-new-ctest-process'
		--repeat until-pass:10
		-R "^render"
	)

	cmake_src_test
}

src_install() {
	cmake_src_install

	if [[ -d "${ED}/usr/build-scripts" ]]; then
		rm -vr "${ED}/usr/build-scripts" || die
	fi

	if use test; then
		rm \
			"${ED}/usr/bin/test"{render,shade{,_dso}} \
			|| die
	fi

	if use amd64; then
		find "${ED}/usr/$(get_libdir)" -type f  -name 'lib_*_oslexec.so' -print0 \
			| while IFS= read -r -d $'\0' batched_lib; do
			patchelf --set-soname "$(basename "${batched_lib}")" "${batched_lib}" || die
		done
	fi
}
