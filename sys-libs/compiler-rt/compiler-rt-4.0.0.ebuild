# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

# TODO: fix unnecessary dep on Python upstream
inherit cmake-utils flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Compiler runtime library for clang (built-in part)"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://releases.llvm.org/${PV/_//}/${P/_/}.src.tar.xz"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="${PV%_*}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+clang test"

LLVM_SLOT=${SLOT%%.*}
RDEPEND="!=sys-libs/compiler-rt-${SLOT}*:0"
# llvm-4 needed for --cmakedir
DEPEND="
	>=sys-devel/llvm-4
	clang? ( sys-devel/clang )
	test? ( =sys-devel/clang-${PV%_*}*:${LLVM_SLOT} )
	${PYTHON_DEPS}"

S=${WORKDIR}/${P/_/}.src

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

test_compiler() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		# ensure we can use clang before installing compiler-rt
		local -x LDFLAGS="${LDFLAGS} -nodefaultlibs -lc"
		strip-unsupported-flags
	elif ! test_compiler; then
		local extra_flags=( -nodefaultlibs -lc )
		if test_compiler "${extra_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${extra_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${extra_flags[*]}"
		fi
	fi

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${SLOT}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${SLOT}"

		# currently lit covers only sanitizer tests
		-DCOMPILER_RT_INCLUDE_TESTS=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF
	)

	cmake-utils_src_configure
}

src_test() {
	# prepare a test compiler
	# copy clang over since resource_dir is located relatively to binary
	# therefore, we can put our new libraries in it
	mkdir -p "${BUILD_DIR}"/lib/{llvm/${LLVM_SLOT}{/bin,$(get_libdir)},clang/${SLOT}/include} || die
	cp "${EPREFIX}"/usr/lib/llvm/${LLVM_SLOT}/bin/clang{,++} \
		"${BUILD_DIR}"/lib/llvm/${LLVM_SLOT}/bin/ || die
	cp "${EPREFIX}/usr/lib/clang/${SLOT}/include"/*.h \
		"${BUILD_DIR}/lib/clang/${SLOT}/include/" || die

	# builtins are not converted to lit yet, so run them manually
	local tests=() f
	cd "${S}"/test/builtins/Unit || die
	while read -r -d '' f; do
		# ppc subdir is unmaintained and lacks proper guards
		# (and ppc builtins do not seem to be used anyway)
		[[ ${f} == ./ppc/* ]] && continue
		# these are special
		[[ ${f} == ./cpu_model_test.c ]] && continue
		[[ ${f} == ./gcc_personality_test.c ]] && continue
		# unsupported
		[[ ${f} == ./trampoline_setup_test.c ]] && continue
		tests+=( "${f%.c}" )
	done < <(find -name '*.c' -print0)

	{
		echo "check: ${tests[*]/#/check-}" &&
		echo ".PHONY: check ${tests[*]/#/check-}" &&
		for f in "${tests[@]}"; do
			echo "check-${f}: ${f}" &&
			echo "	${f}"
		done
	} > Makefile || die

	local ABI
	for ABI in $(get_all_abis); do
		# not supported at all at the moment
		[[ ${ABI} == x32 ]] && continue

		rm -f "${tests[@]}" || die

		einfo "Running tests for ABI=${ABI}"
		# use -k to run all tests even if some fail
		emake -k \
			CC="${BUILD_DIR}/lib/llvm/${LLVM_SLOT}/bin/clang" \
			CFLAGS="$(get_abi_CFLAGS)" \
			CPPFLAGS='-I../../../lib/builtins' \
			LDFLAGS='-rtlib=compiler-rt' \
			LDLIBS='-lm'
	done
}

src_install() {
	cmake-utils_src_install

	# includes are mistakenly installed for all sanitizers and xray
	rm -rf "${ED}"usr/lib/clang/*/include || die
}
