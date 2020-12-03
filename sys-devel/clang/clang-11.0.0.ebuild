# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit cmake llvm llvm.org multilib-minimal pax-utils \
	python-single-r1 toolchain-funcs

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="https://llvm.org/"
LLVM_COMPONENTS=( clang clang-tools-extra )
LLVM_MANPAGES=pregenerated
LLVM_TEST_COMPONENTS=(
	llvm/lib/Testing/Support
	llvm/utils/{lit,llvm-lit,unittest}
	llvm/utils/{UpdateTestChecks,update_cc_test_checks.py}
)
llvm.org_set_globals

# Keep in sync with sys-devel/llvm
ALL_LLVM_EXPERIMENTAL_TARGETS=( ARC VE )
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore
	"${ALL_LLVM_EXPERIMENTAL_TARGETS[@]}" )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )

# MSVCSetupApi.h: MIT
# sorttable.js: MIT

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86 ~amd64-linux"
IUSE="debug default-compiler-rt default-libcxx default-lld
	doc +static-analyzer test xml kernel_FreeBSD ${ALL_LLVM_TARGETS[*]}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )"
RESTRICT="!test? ( test )"

RDEPEND="
	~sys-devel/llvm-${PV}:${SLOT}=[debug=,${MULTILIB_USEDEP}]
	static-analyzer? ( dev-lang/perl:* )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	${PYTHON_DEPS}"
for x in "${ALL_LLVM_TARGETS[@]}"; do
	RDEPEND+="
		${x}? ( ~sys-devel/llvm-${PV}:${SLOT}[${x}] )"
done
unset x

DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-3.16
	doc? ( dev-python/sphinx )
	xml? ( virtual/pkgconfig )
	${PYTHON_DEPS}"
RDEPEND="${RDEPEND}
	!<sys-devel/llvm-4.0.0_rc:0
	!sys-devel/clang:0"
PDEPEND="
	sys-devel/clang-common
	~sys-devel/clang-runtime-${PV}
	default-compiler-rt? ( =sys-libs/compiler-rt-${PV%_*}* )
	default-libcxx? ( >=sys-libs/libcxx-${PV} )
	default-lld? ( sys-devel/lld )"

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

src_prepare() {
	# create extra parent dir for relative CLANG_RESOURCE_DIR access
	mkdir -p x/y || die
	BUILD_DIR=${WORKDIR}/x/y/clang

	llvm.org_src_prepare

	mv ../clang-tools-extra tools/extra || die
}

check_distribution_components() {
	if [[ ${CMAKE_MAKEFILE_GENERATOR} == ninja ]]; then
		local all_targets=() my_targets=() l
		cd "${BUILD_DIR}" || die

		while read -r l; do
			if [[ ${l} == install-*-stripped:* ]]; then
				l=${l#install-}
				l=${l%%-stripped*}

				case ${l} in
					# meta-targets
					clang-libraries|distribution)
						continue
						;;
					# headers for clang-tidy static library
					clang-tidy-headers)
						continue
						;;
					# tools
					clang|clangd|clang-*)
						;;
					# static libraries
					clang*|findAllSymbols)
						continue
						;;
					# conditional to USE=doc
					docs-clang-html|docs-clang-tools-html)
						use doc || continue
						;;
				esac

				all_targets+=( "${l}" )
			fi
		done < <(ninja -t targets all)

		while read -r l; do
			my_targets+=( "${l}" )
		done < <(get_distribution_components $"\n")

		local add=() remove=()
		for l in "${all_targets[@]}"; do
			if ! has "${l}" "${my_targets[@]}"; then
				add+=( "${l}" )
			fi
		done
		for l in "${my_targets[@]}"; do
			if ! has "${l}" "${all_targets[@]}"; then
				remove+=( "${l}" )
			fi
		done

		if [[ ${#add[@]} -gt 0 || ${#remove[@]} -gt 0 ]]; then
			eqawarn "get_distribution_components() is outdated!"
			eqawarn "   Add: ${add[*]}"
			eqawarn "Remove: ${remove[*]}"
		fi
		cd - >/dev/null || die
	fi
}

get_distribution_components() {
	local sep=${1-;}

	local out=(
		# common stuff
		clang-cmake-exports
		clang-headers
		clang-resource-headers
		libclang-headers

		# libs
		clang-cpp
		libclang
	)

	if multilib_is_native_abi; then
		out+=(
			# common stuff
			bash-autocomplete
			libclang-python-bindings

			# tools
			c-index-test
			clang
			clang-format
			clang-offload-bundler
			clang-offload-wrapper
			clang-refactor
			clang-rename
			clang-scan-deps
			diagtool
			hmaptool

			# extra tools
			clang-apply-replacements
			clang-change-namespace
			clang-doc
			clang-include-fixer
			clang-move
			clang-query
			clang-reorder-fields
			clang-tidy
			clangd
			find-all-symbols
			modularize
			pp-trace
		)

		if llvm_are_manpages_built; then
			out+=(
				# manpages
				docs-clang-man
				docs-clang-tools-man
			)
		fi

		use doc && out+=(
			docs-clang-html
			docs-clang-tools-html
		)

		use static-analyzer && out+=(
			clang-check
			clang-extdef-mapping
			scan-build
			scan-view
		)
	fi

	printf "%s${sep}" "${out[@]}"
}

multilib_src_configure() {
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(ver_cut 1-3 "${llvm_version}")

	local mycmakeargs=(
		-DLLVM_CMAKE_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${SLOT}/share/man"
		# relative to bindir
		-DCLANG_RESOURCE_DIR="../../../../lib/clang/${clang_version}"

		-DBUILD_SHARED_LIBS=OFF
		-DCLANG_LINK_CLANG_DYLIB=ON
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)

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
		-DCLANG_DEFAULT_LINKER=$(usex default-lld lld "")

		-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
		-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)

		-DPython3_EXECUTABLE="${PYTHON}"
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	if multilib_is_native_abi; then
		local build_docs=OFF
		if llvm_are_manpages_built; then
			build_docs=ON
			mycmakeargs+=(
				-DLLVM_BUILD_DOCS=ON
				-DLLVM_ENABLE_SPHINX=ON
				-DCLANG_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
				-DCLANG-TOOLS_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/tools-extra"
				-DSPHINX_WARNINGS_AS_ERRORS=OFF
			)
		fi

		mycmakeargs+=(
			# normally copied from LLVM_INCLUDE_DOCS but the latter
			# is lacking value in stand-alone builds
			-DCLANG_INCLUDE_DOCS=${build_docs}
			-DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=${build_docs}
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
		[[ -x "/usr/bin/clang-tblgen" ]] \
			|| die "/usr/bin/clang-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DCLANG_TABLEGEN=/usr/bin/clang-tblgen
		)
	fi

	# LLVM can have very high memory consumption while linking,
	# exhausting the limit on 32-bit linker executable
	use x86 && local -x LDFLAGS="${LDFLAGS} -Wl,--no-keep-memory"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure

	multilib_is_native_abi && check_distribution_components
}

multilib_src_compile() {
	cmake_build distribution

	# provide a symlink for tests
	if [[ ! -L ${WORKDIR}/lib/clang ]]; then
		mkdir -p "${WORKDIR}"/lib || die
		ln -s "${BUILD_DIR}/$(get_libdir)/clang" "${WORKDIR}"/lib/clang || die
	fi
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-clang
	multilib_is_native_abi &&
		cmake_build check-clang-tools check-clangd
}

src_install() {
	MULTILIB_WRAPPED_HEADERS=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	# Move runtime headers to /usr/lib/clang, where they belong
	mv "${ED}"/usr/include/clangrt "${ED}"/usr/lib/clang || die
	# move (remaining) wrapped headers back
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${SLOT}/include || die

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
		rm "${ED}/usr/lib/llvm/${SLOT}/bin/${i}" || die
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
		rm "${ED}"/usr/lib/clang/${clang_full_version}/include/{std,float,iso,limits,tgmath,varargs}*.h || die
	fi
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install-distribution

	# move headers to /usr/include for wrapping & ABI mismatch checks
	# (also drop the version suffix from runtime headers)
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${SLOT}/include "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${SLOT}/$(get_libdir)/clang "${ED}"/usr/include/clangrt || die
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
	if use static-analyzer; then
		python_optimize "${ED}"/usr/lib/llvm/${SLOT}/share/scan-view
	fi

	docompress "/usr/lib/llvm/${SLOT}/share/man"
	llvm_install_manpages
	# match 'html' non-compression
	use doc && docompress -x "/usr/share/doc/${PF}/tools-extra"
	# +x for some reason; TODO: investigate
	use static-analyzer && fperms a-x "/usr/lib/llvm/${SLOT}/share/man/man1/scan-build.1"
}

pkg_postinst() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	elog "You can find additional utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${SLOT}/share/clang"
	elog "Some of them are vim integration scripts (with instructions inside)."
	elog "The run-clang-tidy.py script requires the following additional package:"
	elog "  dev-python/pyyaml"
}

pkg_postrm() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi
}
