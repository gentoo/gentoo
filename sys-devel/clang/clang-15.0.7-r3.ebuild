# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit cmake llvm llvm.org multilib multilib-minimal \
	prefix python-single-r1 toolchain-funcs

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="https://llvm.org/"

# MSVCSetupApi.h: MIT
# sorttable.js: MIT

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}g1"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv sparc ~x86 ~amd64-linux ~x64-macos"
IUSE="debug doc +extra ieee-long-double +pie +static-analyzer test xml"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	~sys-devel/llvm-${PV}:${LLVM_MAJOR}=[debug=,${MULTILIB_USEDEP}]
	static-analyzer? ( dev-lang/perl:* )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
"

RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
	>=sys-devel/clang-common-${PV}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
	doc? ( $(python_gen_cond_dep '
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	') )
	xml? ( virtual/pkgconfig )
"
PDEPEND="
	sys-devel/clang-toolchain-symlinks:${LLVM_MAJOR}
	~sys-devel/clang-runtime-${PV}
"

LLVM_COMPONENTS=(
	clang clang-tools-extra cmake
	llvm/lib/Transforms/Hello
)
LLVM_MANPAGES=1
LLVM_TEST_COMPONENTS=(
	llvm/lib/Testing/Support
	llvm/utils/{lit,llvm-lit,unittest}
	llvm/utils/{UpdateTestChecks,update_cc_test_checks.py}
)
LLVM_PATCHSET=${PV/_/-}-r3
LLVM_USE_TARGETS=llvm
llvm.org_set_globals

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
	LLVM_MAX_SLOT=${LLVM_MAJOR} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# create extra parent dir for relative CLANG_RESOURCE_DIR access
	mkdir -p x/y || die
	BUILD_DIR=${WORKDIR}/x/y/clang

	llvm.org_src_prepare

	# add Gentoo Portage Prefix for Darwin (see prefix-dirs.patch)
	eprefixify \
		lib/Lex/InitHeaderSearch.cpp \
		lib/Driver/ToolChains/Darwin.cpp || die

	if ! use prefix-guest && [[ -n ${EPREFIX} ]]; then
		sed -i "/LibDir.*Loader/s@return \"\/\"@return \"${EPREFIX}/\"@" lib/Driver/ToolChains/Linux.cpp || die
	fi
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
		done < <(${NINJA} -t targets all)

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

		aarch64-resource-headers
		arm-common-resource-headers
		arm-resource-headers
		core-resource-headers
		cuda-resource-headers
		hexagon-resource-headers
		hip-resource-headers
		hlsl-resource-headers
		mips-resource-headers
		opencl-resource-headers
		openmp-resource-headers
		ppc-htm-resource-headers
		ppc-resource-headers
		riscv-resource-headers
		systemz-resource-headers
		utility-resource-headers
		ve-resource-headers
		webassembly-resource-headers
		windows-resource-headers
		x86-resource-headers

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
			clang-offload-packager
			clang-offload-wrapper
			clang-refactor
			clang-repl
			clang-rename
			clang-scan-deps
			diagtool
			hmaptool

			# needed for cross-compiling Clang
			clang-tblgen
		)

		if use extra; then
			out+=(
				# extra tools
				clang-apply-replacements
				clang-change-namespace
				clang-doc
				clang-include-fixer
				clang-move
				clang-pseudo
				clang-query
				clang-reorder-fields
				clang-tidy
				clang-tidy-headers
				clangd
				find-all-symbols
				modularize
				pp-trace
			)
		fi

		if llvm_are_manpages_built; then
			out+=( docs-clang-man )
			use extra && out+=( docs-clang-tools-man )
		fi

		if use doc; then
			out+=( docs-clang-html )
			use extra && out+=( docs-clang-tools-html )
		fi

		use static-analyzer && out+=(
			clang-check
			clang-extdef-mapping
			scan-build
			scan-build-py
			scan-view
		)
	fi

	printf "%s${sep}" "${out[@]}"
}

multilib_src_configure() {
	local mycmakeargs=(
		-DDEFAULT_SYSROOT=$(usex prefix-guest "" "${EPREFIX}")
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
		-DCLANG_CONFIG_FILE_SYSTEM_DIR="${EPREFIX}/etc/clang"
		# relative to bindir
		-DCLANG_RESOURCE_DIR="../../../../lib/clang/${LLVM_VERSION}"

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

		# disable using CUDA to autodetect GPU, just build for all
		-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=ON

		-DCLANG_DEFAULT_PIE_ON_LINUX=$(usex pie)

		-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
		-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if ! use elibc_musl; then
		mycmakeargs+=(
			-DPPC_LINUX_DEFAULT_IEEELONGDOUBLE=$(usex ieee-long-double)
		)
	fi

	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${BUILD_DIR}/bin/llvm-lit"
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
				-DSPHINX_WARNINGS_AS_ERRORS=OFF
			)
			if use extra; then
				mycmakeargs+=(
					-DCLANG-TOOLS_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/tools-extra"
				)
			fi
		fi
		mycmakeargs+=(
			-DCLANG_INCLUDE_DOCS=${build_docs}
		)
	fi
	if multilib_native_use extra; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_SOURCE_DIR="${WORKDIR}"/clang-tools-extra
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
		has_version -b sys-devel/clang:${LLVM_MAJOR} ||
			die "sys-devel/clang:${LLVM_MAJOR} is required on the build host."
		local tools_bin=${BROOT}/usr/lib/llvm/${LLVM_MAJOR}/bin
		mycmakeargs+=(
			-DLLVM_TOOLS_BINARY_DIR="${tools_bin}"
			-DCLANG_TABLEGEN="${tools_bin}"/clang-tblgen
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
	local test_targets=( check-clang )
	if multilib_native_use extra; then
		test_targets+=(
			check-clang-tools
			check-clangd
		)
	fi
	cmake_build "${test_targets[@]}"
}

src_install() {
	MULTILIB_WRAPPED_HEADERS=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	# Move runtime headers to /usr/lib/clang, where they belong
	mv "${ED}"/usr/include/clangrt "${ED}"/usr/lib/clang || die
	# move (remaining) wrapped headers back
	if use extra; then
		mv "${T}"/clang-tidy "${ED}"/usr/include/ || die
	fi
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include || die

	# Apply CHOST and version suffix to clang tools
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
		rm "${ED}/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}" || die
		dosym "clang-${LLVM_MAJOR}" "/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}-${LLVM_MAJOR}"
		dosym "${i}-${LLVM_MAJOR}" "/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}"
	done

	# now create target symlinks for all supported ABIs
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for i in "${clang_tools[@]}"; do
			dosym "${i}-${LLVM_MAJOR}" \
				"/usr/lib/llvm/${LLVM_MAJOR}/bin/${abi_chost}-${i}-${LLVM_MAJOR}"
			dosym "${abi_chost}-${i}-${LLVM_MAJOR}" \
				"/usr/lib/llvm/${LLVM_MAJOR}/bin/${abi_chost}-${i}"
		done
	done
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install-distribution

	if multilib_is_native_abi; then
		# install clang-*-wrapper tools
		# https://bugs.gentoo.org/904143
		exeinto "/usr/lib/llvm/${LLVM_MAJOR}/bin"
		doexe "${BUILD_DIR}"/bin/clang-{linker,nvlink}-wrapper
	fi

	# move headers to /usr/include for wrapping & ABI mismatch checks
	# (also drop the version suffix from runtime headers)
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/clang "${ED}"/usr/include/clangrt || die
	if multilib_native_use extra; then
		# don't wrap clang-tidy headers, the list is too long
		# (they're fine for non-native ABI but enabling the targets is problematic)
		mv "${ED}"/usr/include/clang-tidy "${T}/" || die
	fi
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
	if use static-analyzer; then
		python_optimize "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/share/scan-view
	fi

	docompress "/usr/lib/llvm/${LLVM_MAJOR}/share/man"
	llvm_install_manpages
	# match 'html' non-compression
	use doc && docompress -x "/usr/share/doc/${PF}/tools-extra"
	# +x for some reason; TODO: investigate
	use static-analyzer && fperms a-x "/usr/lib/llvm/${LLVM_MAJOR}/share/man/man1/scan-build.1"
}

pkg_postinst() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	elog "You can find additional utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/clang"
	if use extra; then
		elog "Some of them are vim integration scripts (with instructions inside)."
		elog "The run-clang-tidy.py script requires the following additional package:"
		elog "  dev-python/pyyaml"
	fi
}

pkg_postrm() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi
}
