# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic llvm \
	multiprocessing python-any-r1

MY_P=compiler-rt-${PV/_/}.src
LLVM_P=llvm-${PV/_/}.src

DESCRIPTION="Compiler runtime libraries for clang (sanitizers & xray)"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${MY_P}.tar.xz
	test? ( https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${LLVM_P}.tar.xz )"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="${PV%_*}"
KEYWORDS="amd64 arm arm64 ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+clang +libfuzzer +profile +sanitize test +xray elibc_glibc"
# FIXME: libfuzzer does not enable all its necessary dependencies
REQUIRED_USE="libfuzzer? ( || ( sanitize xray ) )"
RESTRICT="!test? ( test ) !clang? ( test )"

CLANG_SLOT=${SLOT%%.*}
# llvm-6 for new lit options
DEPEND="
	>=sys-devel/llvm-6
	clang? ( sys-devel/clang )
	elibc_glibc? ( net-libs/libtirpc )
	test? (
		!<sys-apps/sandbox-2.13
		$(python_gen_any_dep ">=dev-python/lit-5[\${PYTHON_USEDEP}]")
		=sys-devel/clang-${PV%_*}*:${CLANG_SLOT}
		sys-libs/compiler-rt:${SLOT} )
	${PYTHON_DEPS}"

S=${WORKDIR}/${MY_P}

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
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
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	einfo "Unpacking ${MY_P}.tar.xz ..."
	tar -xf "${DISTDIR}/${MY_P}.tar.xz" || die

	if use test; then
		einfo "Unpacking parts of ${LLVM_P}.tar.xz ..."
		tar -xf "${DISTDIR}/${LLVM_P}.tar.xz" \
			"${LLVM_P}"/utils/unittest || die
		mv "${LLVM_P}" llvm || die
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	if use test; then
		# remove tests that are (still) broken by new glibc
		# https://bugs.llvm.org/show_bug.cgi?id=36065
		if use elibc_glibc && has_version '>=sys-libs/glibc-2.25'; then
			rm test/lsan/TestCases/Linux/fork_and_leak.cc || die
		fi
	fi
}

src_configure() {
	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${SLOT}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${SLOT}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		# built-ins installed by sys-libs/compiler-rt
		-DCOMPILER_RT_BUILD_BUILTINS=OFF
		-DCOMPILER_RT_BUILD_LIBFUZZER=$(usex libfuzzer)
		-DCOMPILER_RT_BUILD_PROFILE=$(usex profile)
		-DCOMPILER_RT_BUILD_SANITIZERS=$(usex sanitize)
		-DCOMPILER_RT_BUILD_XRAY=$(usex xray)
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-vv;-j;${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}"

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
			# disable use of SDK for the system itself
			-DDARWIN_macosx_CACHED_SYSROOT=/
		)
	fi

	cmake-utils_src_configure

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

	cmake-utils_src_make check-all
}
