# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic python-any-r1

DESCRIPTION="Compiler runtime libraries for clang (sanitizers & xray)"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://www.llvm.org/pre-releases/${PV/_//}/compiler-rt-${PV/_/}.src.tar.xz
	test? ( http://www.llvm.org/pre-releases/${PV/_//}/llvm-${PV/_/}.src.tar.xz )"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0/${PV%.*}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

RDEPEND="!<sys-devel/llvm-${PV}"
# llvm-4 needed for --cmakedir
DEPEND="${RDEPEND}
	>=sys-devel/llvm-4
	test? (
		app-portage/unsandbox
		$(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]")
		~sys-devel/clang-${PV}
		~sys-libs/compiler-rt-${PV} )
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/compiler-rt-${PV/_/}.src

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

src_unpack() {
	default

	if use test; then
		mv llvm-* llvm || die
	fi
}

src_configure() {
	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(get_version_component_range 1-3 "${llvm_version}")
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${clang_version}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${clang_version}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		# built-ins installed by sys-libs/compiler-rt
		-DCOMPILER_RT_BUILD_BUILTINS=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=ON
		-DCOMPILER_RT_BUILD_XRAY=ON
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
			-DLIT_COMMAND="${EPREFIX}/usr/bin/unsandbox;${EPREFIX}/usr/bin/lit"

			# they are created during src_test()
			-DCOMPILER_RT_TEST_COMPILER="${BUILD_DIR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${BUILD_DIR}/bin/clang++"
		)

		# same flags are passed for build & tests, so we need to strip
		# them down to a subset supported by clang
		filter-flags -msahf -frecord-gcc-switches
	fi

	cmake-utils_src_configure

	if use test; then
		local sys_dir=( "${EPREFIX}/usr/lib/clang/${clang_version}/lib"/* )
		[[ -e ${sys_dir} ]] || die "Unable to find ${sys_dir}"
		[[ ${#sys_dir[@]} -eq 1 ]] || die "Non-deterministic compiler-rt install: ${sys_dir[@]}"

		# copy clang over since resource_dir is located relatively to binary
		# therefore, we can put our new libraries in it
		mkdir -p "${BUILD_DIR}"/{bin,$(get_libdir),lib/clang/"${clang_version}"/include} || die
		cp "${EPREFIX}/usr/bin/clang" "${EPREFIX}/usr/bin/clang++" \
			"${BUILD_DIR}"/bin/ || die
		cp "${EPREFIX}/usr/lib/clang/${clang_version}/include"/*.h \
			"${BUILD_DIR}/lib/clang/${clang_version}/include/" || die
		cp "${sys_dir}"/*builtins*.a \
			"${BUILD_DIR}/lib/clang/${clang_version}/lib/${sys_dir##*/}/" || die
		# we also need LLVMgold.so for gold-based tests
		if [[ -f ${EPREFIX}/usr/$(get_libdir)/LLVMgold.so ]]; then
			ln -s "${EPREFIX}/usr/$(get_libdir)/LLVMgold.so" \
				"${BUILD_DIR}/$(get_libdir)/" || die
		fi
	fi
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake-utils_src_make check-all
}
