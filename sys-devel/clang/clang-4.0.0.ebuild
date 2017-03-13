# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils flag-o-matic llvm multilib-minimal \
	python-single-r1 toolchain-funcs pax-utils versionator

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://releases.llvm.org/${PV/_//}/cfe-${PV/_/}.src.tar.xz
	http://releases.llvm.org/${PV/_//}/clang-tools-extra-${PV/_/}.src.tar.xz
	test? ( http://releases.llvm.org/${PV/_//}/llvm-${PV/_/}.src.tar.xz )"

# Keep in sync with sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="UoI-NCSA"
SLOT="$(get_major_version)"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug default-compiler-rt default-libcxx +doc multitarget
	+static-analyzer test xml elibc_musl kernel_FreeBSD ${ALL_LLVM_TARGETS[*]}"

RDEPEND="
	~sys-devel/llvm-${PV}:${SLOT}=[debug=,${LLVM_TARGET_USEDEPS// /,},${MULTILIB_USEDEP}]
	static-analyzer? ( dev-lang/perl:* )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	${PYTHON_DEPS}"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? ( ~dev-python/lit-${PV}[${PYTHON_USEDEP}] )
	xml? ( virtual/pkgconfig )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"
RDEPEND="${RDEPEND}
	!<sys-devel/llvm-4.0.0_rc:0
	!sys-devel/clang:0"
PDEPEND="
	~sys-devel/clang-runtime-${PV}
	default-compiler-rt? ( =sys-libs/compiler-rt-${PV%_*}* )
	default-libcxx? ( sys-libs/libcxx )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )
	multitarget? ( ${ALL_LLVM_TARGETS[*]} )"

# We need extra level of indirection for CLANG_RESOURCE_DIR
S=${WORKDIR}/x/y/cfe-${PV/_/}.src

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

# Multilib notes:
# 1. ABI_* flags control ABIs libclang* is built for only.
# 2. clang is always capable of compiling code for all ABIs for enabled
#    target. However, you will need appropriate crt* files (installed
#    e.g. by sys-devel/gcc and sys-libs/glibc).
# 3. ${CHOST}-clang wrappers are always installed for all ABIs included
#    in the current profile (i.e. alike supported by sys-devel/gcc).
#
# Therefore: use sys-devel/clang[${MULTILIB_USEDEP}] only if you need
# multilib clang* libraries (not runtime, not wrappers).

check_space() {
	local build_size=650

	if use debug; then
		ewarn "USE=debug is known to increase the size of package considerably"
		ewarn "and cause the tests to fail."
		ewarn

		(( build_size *= 14 ))
	elif is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "The C++ compiler -g option is known to increase the size of the package"
		ewarn "considerably. If you run out of space, please consider removing it."
		ewarn

		(( build_size *= 10 ))
	fi

	# Multiply by number of ABIs :).
	local abis=( $(multilib_get_enabled_abis) )
	(( build_size *= ${#abis[@]} ))

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space

	LLVM_MAX_SLOT=${SLOT} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_unpack() {
	# create extra parent dirs for CLANG_RESOURCE_DIR
	mkdir -p x/y || die
	cd x/y || die

	default

	mv clang-tools-extra-* "${S}"/tools/extra || die
	if use test; then
		mv llvm-* "${WORKDIR}"/llvm || die
	fi
}

src_prepare() {
	# fix finding compiler-rt libs
	eapply "${FILESDIR}"/9999/0001-Driver-Use-arch-type-to-find-compiler-rt-libraries-o.patch

	# fix stand-alone doc build
	eapply "${FILESDIR}"/9999/0007-cmake-Support-stand-alone-Sphinx-doxygen-doc-build.patch

	# fix value of ATOMIC_*_LOCK_FREE
	# (backport, temporary reverted upstream because of FreeBSD issues)
	eapply "${FILESDIR}"/4.0.0/0001-Frontend-Correct-values-of-ATOMIC_-_LOCK_FREE-to-mat.patch

	cd tools/extra || die
	# fix stand-alone test build for extra tools
	eapply "${FILESDIR}"/4.0.0/extra/0001-test-Fix-test-dependencies-when-using-installed-tool.patch
	eapply "${FILESDIR}"/4.0.0/extra/0002-test-Fix-clang-library-dir-in-LD_LIBRARY_PATH-For-st.patch
	cd - >/dev/null || die

	# User patches
	eapply_user
}

multilib_src_configure() {
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(get_version_component_range 1-3 "${llvm_version}")

	local mycmakeargs=(
		# ensure that the correct llvm-config is used
		-DLLVM_CONFIG="$(type -P "${CHOST}-llvm-config")"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		# relative to bindir
		-DCLANG_RESOURCE_DIR="../../../../lib/clang/${clang_version}"

		-DBUILD_SHARED_LIBS=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		# these are not propagated reliably, so redefine them
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=$(usex !xml)
		# libgomp support fails to find headers without explicit -I
		# furthermore, it provides only syntax checking
		-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

		# override default stdlib and rtlib
		-DCLANG_DEFAULT_CXX_STDLIB=$(usex default-libcxx libc++ "")
		-DCLANG_DEFAULT_RTLIB=$(usex default-compiler-rt compiler-rt "")

		-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
		-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF

			# workaround pthread
			-DPTHREAD_LIB=-pthread
		)
		use doc && mycmakeargs+=(
			-DCLANG_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
		)
	else
		mycmakeargs+=(
			-DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF
		)
	fi

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/clang-tblgen" ]] \
			|| die "/usr/bin/clang-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DCLANG_TABLEGEN=/usr/bin/clang-tblgen
		)
	fi

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile

	# provide a symlink for tests
	if [[ ! -L ${WORKDIR}/lib/clang ]]; then
		mkdir -p "${WORKDIR}"/lib || die
		ln -s "${BUILD_DIR}/$(get_libdir)/clang" "${WORKDIR}"/lib/clang || die
	fi
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-clang
	multilib_is_native_abi && cmake-utils_src_make check-clang-tools
}

src_install() {
	MULTILIB_WRAPPED_HEADERS=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	# Move runtime headers to /usr/lib/clang, where they belong
	mv "${ED%/}"/usr/include/clangrt "${ED%/}"/usr/lib/clang || die
	# move (remaining) wrapped headers back
	mv "${ED%/}"/usr/include "${ED%/}"/usr/lib/llvm/${SLOT}/include || die

	# Apply CHOST and version suffix to clang tools
	# note: we use two version components here (vs 3 in runtime path)
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(get_version_component_range 1-2 "${llvm_version}")
	local clang_full_version=$(get_version_component_range 1-3 "${llvm_version}")
	local clang_tools=( clang clang++ clang-cl clang-cpp )
	local abi i

	# cmake gives us:
	# - clang-X.Y
	# - clang -> clang-X.Y
	# - clang++, clang-cl, clang-cpp -> clang
	# we want to have:
	# - clang-X.Y
	# - clang++-X.Y, clang-cl-X.Y, clang-cpp-X.Y -> clang-X.Y
	# - clang, clang++, clang-cl, clang-cpp -> clang*-X.Y
	# also in CHOST variant
	for i in "${clang_tools[@]:1}"; do
		rm "${ED%/}/usr/lib/llvm/${SLOT}/bin/${i}" || die
		dosym "clang-${clang_version}" "/usr/lib/llvm/${SLOT}/bin/${i}-${clang_version}"
		dosym "${i}-${clang_version}" "/usr/lib/llvm/${SLOT}/bin/${i}"
	done

	# now create target symlinks for all supported ABIs
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for i in "${clang_tools[@]}"; do
			dosym "${i}-${clang_version}" \
				"/usr/lib/llvm/${SLOT}/bin/${abi_chost}-${i}-${clang_version}"
			dosym "${abi_chost}-${i}-${clang_version}" \
				"/usr/lib/llvm/${SLOT}/bin/${abi_chost}-${i}"
		done
	done

	# Remove unnecessary headers on FreeBSD, bug #417171
	if use kernel_FreeBSD; then
		rm "${ED}"usr/lib/clang/${clang_full_version}/include/{std,float,iso,limits,tgmath,varargs}*.h || die
	fi
}

multilib_src_install() {
	cmake-utils_src_install

	# move headers to /usr/include for wrapping & ABI mismatch checks
	# (also drop the version suffix from runtime headers)
	rm -rf "${ED%/}"/usr/include || die
	mv "${ED%/}"/usr/lib/llvm/${SLOT}/include "${ED%/}"/usr/include || die
	mv "${ED%/}"/usr/lib/llvm/${SLOT}/$(get_libdir)/clang "${ED%/}"/usr/include/clangrt || die
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
	if use static-analyzer; then
		python_optimize "${ED}"usr/lib/llvm/${SLOT}/share/scan-view
	fi
}
