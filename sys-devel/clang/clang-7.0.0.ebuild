# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eapi7-ver flag-o-matic llvm \
	multilib-minimal multiprocessing pax-utils prefix python-single-r1 \
	toolchain-funcs

MY_P=cfe-${PV/_/}.src
EXTRA_P=clang-tools-extra-${PV/_/}.src
LLVM_P=llvm-${PV/_/}.src

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="https://llvm.org/"
SRC_URI="https://releases.llvm.org/${PV/_//}/${MY_P}.tar.xz
	https://releases.llvm.org/${PV/_//}/${EXTRA_P}.tar.xz
	test? ( https://releases.llvm.org/${PV/_//}/${LLVM_P}.tar.xz )
	!doc? ( https://dev.gentoo.org/~mgorny/dist/llvm/llvm-${PV}-manpages.tar.bz2 )"

# Keep in sync with sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug default-compiler-rt default-libcxx doc +static-analyzer
	test xml z3 kernel_FreeBSD ${ALL_LLVM_TARGETS[*]}"
RESTRICT="!test? ( test )"

RDEPEND="
	~sys-devel/llvm-${PV}:${SLOT}=[debug=,${LLVM_TARGET_USEDEPS// /,},${MULTILIB_USEDEP}]
	static-analyzer? (
		dev-lang/perl:*
		z3? ( sci-mathematics/z3:0= )
	)
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	${PYTHON_DEPS}"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	xml? ( virtual/pkgconfig )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"
RDEPEND="${RDEPEND}
	!<sys-devel/llvm-4.0.0_rc:0
	!sys-devel/clang:0"
PDEPEND="
	sys-devel/clang-common
	~sys-devel/clang-runtime-${PV}
	default-compiler-rt? ( =sys-libs/compiler-rt-${PV%_*}* )
	default-libcxx? ( >=sys-libs/libcxx-${PV} )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )"

# We need extra level of indirection for CLANG_RESOURCE_DIR
S=${WORKDIR}/x/y/${MY_P}

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

PATCHES=(
	# add Prefix include paths for Darwin
	"${FILESDIR}"/6.0.1/darwin_prefix-include-paths.patch

	# add tblgen for cross compile
	# https://bugs.gentoo.org/667094
	"${FILESDIR}"/fix-tblgen.patch
)

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

pkg_setup() {
	LLVM_MAX_SLOT=${SLOT} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_unpack() {
	# create extra parent dir for CLANG_RESOURCE_DIR
	mkdir -p x/y || die
	cd x/y || die

	einfo "Unpacking ${MY_P}.tar.xz ..."
	tar -xf "${DISTDIR}/${MY_P}.tar.xz" || die
	einfo "Unpacking ${EXTRA_P}.tar.xz ..."
	tar -xf "${DISTDIR}/${EXTRA_P}.tar.xz" || die

	mv "${EXTRA_P}" "${S}"/tools/extra || die
	if use test; then
		einfo "Unpacking parts of ${LLVM_P}.tar.xz ..."
		tar -xf "${DISTDIR}/${LLVM_P}.tar.xz" \
			"${LLVM_P}"/lib/Testing/Support \
			"${LLVM_P}"/utils/{lit,llvm-lit,unittest} || die
		mv "${LLVM_P}" "${WORKDIR}"/llvm || die
	fi

	if ! use doc; then
		einfo "Unpacking llvm-${PV}-manpages.tar.bz2 ..."
		tar -xf "${DISTDIR}/llvm-${PV}-manpages.tar.bz2" || die
	fi
}

src_prepare() {
	cmake-utils_src_prepare
	eprefixify lib/Frontend/InitHeaderSearch.cpp
}

multilib_src_configure() {
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(ver_cut 1-3 "${llvm_version}")

	local mycmakeargs=(
		# ensure that the correct llvm-config is used
		-DLLVM_CONFIG="$(type -P "${CHOST}-llvm-config")"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${SLOT}/share/man"
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
		# z3 is not multilib-friendly
		-DCLANG_ANALYZER_BUILD_Z3=$(multilib_native_usex z3)
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_LIT_ARGS="-vv;-j;${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}"
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			# normally copied from LLVM_INCLUDE_DOCS but the latter
			# is lacking value in stand-alone builds
			-DCLANG_INCLUDE_DOCS=$(usex doc)
			-DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=$(usex doc)
		)
		use doc && mycmakeargs+=(
			-DLLVM_BUILD_DOCS=ON
			-DLLVM_ENABLE_SPHINX=ON
			-DCLANG_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
			-DCLANG-TOOLS_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/tools-extra"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
		)
		use z3 && mycmakeargs+=(
			-DZ3_INCLUDE_DIR="${EPREFIX}/usr/include/z3"
		)
	else
		mycmakeargs+=(
			-DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF
		)
	fi

	if [[ -n ${EPREFIX} ]]; then
		mycmakeargs+=(
			-DGCC_INSTALL_PREFIX="${EPREFIX}/usr"
		)
	fi

	if tc-is-cross-compiler; then
		local tblgen="${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang-tblgen"
		[[ -x "${tblgen}" ]] \
			|| die "${tblgen} not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=True
			-DLLVM_TABLEGEN="${tblgen}"
			-DLLVM_CONFIG="${EPREFIX}/usr/lib/llvm/${SLOT}/bin/llvm-config"
		)
	fi

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
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
	local clang_version=$(ver_cut 1 "${llvm_version}")
	local clang_full_version=$(ver_cut 1-3 "${llvm_version}")
	local clang_tools=( clang clang++ clang-cl clang-cpp )
	local abi i

	# cmake gives us:
	# - clang-X
	# - clang -> clang-X
	# - clang++, clang-cl, clang-cpp -> clang
	# we want to have:
	# - clang-X
	# - clang++-X, clang-cl-X, clang-cpp-X -> clang-X
	# - clang, clang++, clang-cl, clang-cpp -> clang*-X
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

	# install pre-generated manpages
	if ! use doc; then
		insinto "/usr/lib/llvm/${SLOT}/share/man/man1"
		doins "${WORKDIR}/x/y/llvm-${PV}-manpages/clang"/*.1
	fi

	docompress "/usr/lib/llvm/${SLOT}/share/man"
	# match 'html' non-compression
	use doc && docompress -x "/usr/share/doc/${PF}/tools-extra"
	# +x for some reason; TODO: investigate
	use static-analyzer && fperms a-x "/usr/lib/llvm/${SLOT}/share/man/man1/scan-build.1"
}

pkg_postinst() {
	if [[ ${ROOT} == / && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	elog "You can find additional utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${SLOT}/share/clang"
	elog "To use these scripts, you will need Python 2.7. Some of them are vim"
	elog "integration scripts (with instructions inside). The run-clang-tidy.py"
	elog "scripts requires the following additional package:"
	elog "  dev-python/pyyaml"
}

pkg_postrm() {
	if [[ ${ROOT} == / && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi
}
