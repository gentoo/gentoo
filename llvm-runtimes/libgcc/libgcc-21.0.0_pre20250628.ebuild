# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake crossdev flag-o-matic llvm.org llvm-utils python-any-r1
inherit toolchain-funcs

DESCRIPTION="Compiler runtime library for clang, compatible with libgcc_s"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
IUSE="debug test"

DEPEND="
	~llvm-runtimes/libunwind-${PV}[static-libs]
"
RDEPEND="
	${DEPEND}
	!sys-devel/gcc
"
BDEPEND="
	llvm-core/clang:${LLVM_MAJOR}
	test? (
		$(python_gen_any_dep ">=dev-python/lit-15[\${PYTHON_USEDEP}]")
		=llvm-core/clang-${LLVM_VERSION}*:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
"

LLVM_COMPONENTS=( compiler-rt cmake llvm/cmake llvm-libgcc )
LLVM_TEST_COMPONENTS=( llvm/include/llvm/TargetParser )
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version ">=dev-python/lit-15[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if target_is_not_host || tc-is-cross-compiler ; then
		# strips vars like CFLAGS="-march=x86_64-v3" for non-x86 architectures
		CHOST=${CTARGET} strip-unsupported-flags
		# overrides host docs otherwise
		DOCS=()
	fi
	python-any-r1_pkg_setup
}

src_configure() {
	# We need to build a separate copy of compiler-rt, because we need to disable the
	# COMPILER_RT_BUILTINS_HIDE_SYMBOLS option - compatibility with libgcc requires
	# visibility of all symbols.

	llvm_prepend_path "${LLVM_MAJOR}"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	export CC=${CTARGET}-clang CXX=${CTARGET}-clang++
	strip-unsupported-flags

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${LLVM_MAJOR}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		-DCOMPILER_RT_BUILD_CRT=OFF
		-DCOMPILER_RT_BUILD_CTX_PROFILE=OFF
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
		-DCOMPILER_RT_BUILD_MEMPROF=OFF
		-DCOMPILER_RT_BUILD_ORC=OFF
		-DCOMPILER_RT_BUILD_PROFILE=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF

		-DCOMPILER_RT_BUILTINS_HIDE_SYMBOLS=OFF

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	# disable building non-native runtimes since we don't do multilib
	if use amd64; then
		mycmakeargs+=(
			-DCAN_TARGET_i386=OFF
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"

			-DCOMPILER_RT_TEST_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang++"
		)
	fi

	cmake_src_configure
}

# Usage: deps
gen_ldscript() {
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	cat <<-END_LDSCRIPT
/* GNU ld script
   Include missing dependencies
*/
${output_format}
GROUP ( $@ )
END_LDSCRIPT
}

src_compile() {
	cmake_src_compile

	local rtlib=$(
		"${CC}" -rtlib=compiler-rt -resource-dir="${BUILD_DIR}" \
			-print-libgcc-file-name || die
	)

	# Use the llvm-libgcc's version script to produce libgcc.{a,so}, which
	# combines compiler-rt and libunwind into a libgcc replacement.
	#
	# What we do here is similar to what upstream does[0], with the following
	# differences:
	#
	# * We build the local copy of compiler-rt manually, to have a full control
	#   over CMake options.
	# * Upstream links the locally built copy of libunwind statically. We link the
	#   system-wide libunwind dynamically.
	#
	# [0] https://github.com/llvm/llvm-project/blob/llvmorg-19.1.7/llvm-libgcc/CMakeLists.txt#L102-L120
	"${CC}" -E -xc \
		"${WORKDIR}/llvm-libgcc/gcc_s.ver.in" \
		-o gcc_s.ver || die
	"${CC}" -nostdlib \
		${LDFLAGS} \
		-Wl,--version-script,gcc_s.ver \
		-Wl,--undefined-version \
		-Wl,--whole-archive \
		"${rtlib}" \
		-Wl,-soname,libgcc_s.so.1.0 \
		-lc -lunwind -shared \
		-o libgcc_s.so.1.0 || die
	# Generate libgcc_s.so ldscript for inclusion of libunwind as a
	# dependency so that `clang -lgcc_s` works out of the box.
	gen_ldscript libgcc_s.so.1.0 libunwind.so.1.0 > libgcc_s.so || die
	cp "${rtlib}" libgcc.a || die
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake_build check-builtins
}

src_install() {
	local libdir=$(get_libdir)
	dolib.so libgcc_s.so.1.0 libgcc_s.so
	dolib.a libgcc.a
	dosym libgcc_s.so.1.0 "/usr/${libdir}/libgcc_s.so.1"
	dosym libunwind.a "/usr/${libdir}/libgcc_eh.a"
}
