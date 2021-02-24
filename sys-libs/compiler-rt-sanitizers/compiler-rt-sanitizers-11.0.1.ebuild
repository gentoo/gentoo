# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit check-reqs cmake flag-o-matic llvm llvm.org python-any-r1

DESCRIPTION="Compiler runtime libraries for clang (sanitizers & xray)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="$(ver_cut 1-3)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="+clang test elibc_glibc"
# base targets
IUSE+=" +libfuzzer +profile +xray"
# sanitizer targets, keep in sync with config-ix.cmake
# NB: ubsan, scudo deliberately match two entries
SANITIZER_FLAGS=(
	asan dfsan lsan msan hwasan tsan ubsan safestack cfi scudo
	shadowcallstack gwp-asan
)
IUSE+=" ${SANITIZER_FLAGS[@]/#/+}"
REQUIRED_USE="
	|| ( ${SANITIZER_FLAGS[*]} libfuzzer profile xray )
	gwp-asan? ( scudo )
	ubsan? ( cfi )"
RESTRICT="!test? ( test ) !clang? ( test )"

CLANG_SLOT=${SLOT%%.*}
# llvm-6 for new lit options
DEPEND="
	>=sys-devel/llvm-6"
BDEPEND="
	>=dev-util/cmake-3.16
	clang? ( sys-devel/clang )
	elibc_glibc? ( net-libs/libtirpc )
	test? (
		!<sys-apps/sandbox-2.13
		$(python_gen_any_dep ">=dev-python/lit-5[\${PYTHON_USEDEP}]")
		=sys-devel/clang-${PV%_*}*:${CLANG_SLOT}
		sys-libs/compiler-rt:${SLOT}
	)
	${PYTHON_DEPS}"

LLVM_COMPONENTS=( compiler-rt )
LLVM_TEST_COMPONENTS=( llvm/lib/Testing/Support llvm/utils/unittest )
llvm.org_set_globals

PATCHES=(
	"${FILESDIR}/11.1.0/compiler-rt-prefix-paths.patch"
)

python_check_deps() {
	use test || return 0
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

check_space() {
	if use test; then
		local CHECKREQS_DISK_BUILD=11G
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	sed -i -e 's:-Werror::' lib/tsan/go/buildgo.sh || die

	local flag
	for flag in "${SANITIZER_FLAGS[@]}"; do
		if ! use "${flag}"; then
			local cmake_flag=${flag/-/_}
			sed -i -e "/COMPILER_RT_HAS_${cmake_flag^^}/s:TRUE:FALSE:" \
				cmake/config-ix.cmake || die
		fi
	done

	if use asan && ! use profile; then
		# TODO: fix these tests to be skipped upstream
		rm test/asan/TestCases/asan_and_llvm_coverage_test.cpp || die
	fi

	# broken with new glibc
	sed -i -e '/EXPECT_EQ.*ThreadDescriptorSize/d' \
		lib/sanitizer_common/tests/sanitizer_linux_test.cpp || die

	llvm.org_src_prepare
}

src_configure() {
	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/compiler-rt_build

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	local flag want_sanitizer=OFF
	for flag in "${SANITIZER_FLAGS[@]}"; do
		if use "${flag}"; then
			want_sanitizer=ON
			break
		fi
	done

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${SLOT}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${SLOT}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		# builtins & crt installed by sys-libs/compiler-rt
		-DCOMPILER_RT_BUILD_BUILTINS=OFF
		-DCOMPILER_RT_BUILD_CRT=OFF
		-DCOMPILER_RT_BUILD_LIBFUZZER=$(usex libfuzzer)
		-DCOMPILER_RT_BUILD_PROFILE=$(usex profile)
		-DCOMPILER_RT_BUILD_SANITIZERS="${want_sanitizer}"
		-DCOMPILER_RT_BUILD_XRAY=$(usex xray)

		-DPython3_EXECUTABLE="${PYTHON}"
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"

			# they are created during src_test()
			-DCOMPILER_RT_TEST_COMPILER="${BUILD_DIR}/lib/llvm/${CLANG_SLOT}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${BUILD_DIR}/lib/llvm/${CLANG_SLOT}/bin/clang++"
		)

		# same flags are passed for build & tests, so we need to strip
		# them down to a subset supported by clang
		CC=${EPREFIX}/usr/lib/llvm/${CLANG_SLOT}/bin/clang \
		CXX=${EPREFIX}/usr/lib/llvm/${CLANG_SLOT}/bin/clang++ \
		strip-unsupported-flags
	fi

	if use prefix && [[ "${CHOST}" == *-darwin* ]] ; then
		mycmakeargs+=(
			# setting -isysroot is disabled with compiler-rt-prefix-paths.patch
			# this allows adding arm64 support using SDK in EPREFIX
			-DDARWIN_macosx_CACHED_SYSROOT="${EPREFIX}/MacOSX.sdk"
			# Set version based on the SDK in EPREFIX
			# This disables i386 for SDK >= 10.15
			# Will error if has_use tsan and SDK < 10.12
			-DDARWIN_macosx_OVERRIDE_SDK_VERSION="$(realpath ${EPREFIX}/MacOSX.sdk | sed -e 's/.*MacOSX\(.*\)\.sdk/\1/')"
			# Use our libtool instead of looking it up with xcrun
			-DCMAKE_LIBTOOL="${EPREFIX}/usr/bin/${CHOST}-libtool"
		)
	fi

	cmake_src_configure

	if use test; then
		local sys_dir=( "${EPREFIX}"/usr/lib/clang/${SLOT}/lib/* )
		[[ -e ${sys_dir} ]] || die "Unable to find ${sys_dir}"
		[[ ${#sys_dir[@]} -eq 1 ]] || die "Non-deterministic compiler-rt install: ${sys_dir[*]}"

		# copy clang over since resource_dir is located relatively to binary
		# therefore, we can put our new libraries in it
		mkdir -p "${BUILD_DIR}"/lib/{llvm/${CLANG_SLOT}/{bin,$(get_libdir)},clang/${SLOT}/include} || die
		cp "${EPREFIX}"/usr/lib/llvm/${CLANG_SLOT}/bin/clang{,++} \
			"${BUILD_DIR}"/lib/llvm/${CLANG_SLOT}/bin/ || die
		cp "${EPREFIX}"/usr/lib/clang/${SLOT}/include/*.h \
			"${BUILD_DIR}"/lib/clang/${SLOT}/include/ || die
		cp "${sys_dir}"/*builtins*.a \
			"${BUILD_DIR}/lib/clang/${SLOT}/lib/${sys_dir##*/}/" || die
		# we also need LLVMgold.so for gold-based tests
		if [[ -f ${EPREFIX}/usr/lib/llvm/${CLANG_SLOT}/$(get_libdir)/LLVMgold.so ]]; then
			ln -s "${EPREFIX}"/usr/lib/llvm/${CLANG_SLOT}/$(get_libdir)/LLVMgold.so \
				"${BUILD_DIR}"/lib/llvm/${CLANG_SLOT}/$(get_libdir)/ || die
		fi
	fi
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	# disable sandbox to have it stop clobbering LD_PRELOAD
	local -x SANDBOX_ON=0
	# wipe LD_PRELOAD to make ASAN happy
	local -x LD_PRELOAD=

	cmake_build check-all
}
