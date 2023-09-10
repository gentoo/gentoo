# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake llvm.org multilib multilib-minimal pax-utils prefix
inherit python-single-r1 toolchain-funcs

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="https://llvm.org/"

# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. xxhash: BSD.
# 3. MD5 code: public-domain.
# 4. ConvertUTF.h: TODO.
# 5. MSVCSetupApi.h: MIT
# 6. sorttable.js: MIT

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD MIT public-domain rc"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
KEYWORDS=""
IUSE="
	+binutils-plugin +debug debuginfod doc exegesis ieee-long-double libedit
	+libffi ncurses +pie +static-analyzer test xar xml z3 zstd
"
for project in clang clang-tools-extra lld; do
	IUSE+=" llvm_projects_${project}"
done
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	static-analyzer? ( llvm_projects_clang )
	llvm_projects_clang-tools-extra? ( llvm_projects_clang )
"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:0=[${MULTILIB_USEDEP}]
	debuginfod? (
		net-misc/curl:=
		dev-cpp/cpp-httplib:=
	)
	exegesis? ( dev-libs/libpfm:= )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=dev-libs/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	static-analyzer? ( dev-lang/perl:* )
	xar? ( app-arch/xar )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	z3? ( >=sci-mathematics/z3-4.7.1:0=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
	llvm_projects_clang? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	binutils-plugin? ( sys-libs/binutils-libs )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	>=dev-util/cmake-3.16
	sys-devel/gnuconfig
	kernel_Darwin? (
		<sys-libs/libcxx-${LLVM_VERSION}.9999
		>=sys-devel/binutils-apple-5.1
	)
	doc? ( $(python_gen_cond_dep '
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	') )
	libffi? ( virtual/pkgconfig )
"
# There are no file collisions between these versions but having :0
# installed means llvm-config there will take precedence.
RDEPEND="
	${RDEPEND}
	!sys-devel/llvm:0
	llvm_projects_clang? ( ${PYTHON_DEPS} )
"
PDEPEND="
	sys-devel/llvm-common
	sys-devel/llvm-toolchain-symlinks:${LLVM_MAJOR}
	binutils-plugin? ( >=sys-devel/llvmgold-${LLVM_MAJOR} )
	llvm_projects_clang? (
		>=sys-devel/clang-common-${PV}
		~sys-devel/clang-runtime-${PV}
		sys-devel/clang-toolchain-symlinks:${LLVM_MAJOR}
	)
"

LLVM_COMPONENTS=( llvm clang clang-tools-extra cmake libunwind/include/mach-o lld third-party )
LLVM_MANPAGES=1
LLVM_USE_TARGETS=provide
llvm.org_set_globals

python_check_deps() {
	use doc || return 0

	python_has_version -b "dev-python/recommonmark[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]"
}

check_uptodate() {
	local prod_targets=(
		$(sed -n -e '/set(LLVM_ALL_TARGETS/,/)/p' CMakeLists.txt \
			| tail -n +2 | head -n -1)
	)
	local all_targets=(
		lib/Target/*/
	)
	all_targets=( "${all_targets[@]#lib/Target/}" )
	all_targets=( "${all_targets[@]%/}" )

	local exp_targets=() i
	for i in "${all_targets[@]}"; do
		has "${i}" "${prod_targets[@]}" || exp_targets+=( "${i}" )
	done

	if [[ ${exp_targets[*]} != ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]} ]]; then
		eqawarn "ALL_LLVM_EXPERIMENTAL_TARGETS is outdated!"
		eqawarn "    Have: ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]}"
		eqawarn "Expected: ${exp_targets[*]}"
		eqawarn
	fi

	if [[ ${prod_targets[*]} != ${ALL_LLVM_PRODUCTION_TARGETS[*]} ]]; then
		eqawarn "ALL_LLVM_PRODUCTION_TARGETS is outdated!"
		eqawarn "    Have: ${ALL_LLVM_PRODUCTION_TARGETS[*]}"
		eqawarn "Expected: ${prod_targets[*]}"
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
					# shared libs
					LLVM|LLVMgold)
						;;
					# TableGen lib + deps
					LLVMDemangle|LLVMSupport|LLVMTableGen)
						;;
					# testing libraries
					LLVMTestingAnnotations|LLVMTestingSupport)
						;;
					# meta-targets
					clang-libraries|distribution|llvm-libraries)
						continue
						;;
					# tools
					clang|clangd|clang-*)
						;;
					# static libs
					clang*|findAllSymbols|LLVM*)
						continue
						;;
					# used only w/ USE=doc
					docs-clang-html|docs-clang-tools-html|docs-lld-html|docs-llvm-html)
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

src_prepare() {
	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	# Update config.guess to support more systems
	cp "${BROOT}/usr/share/gnuconfig/config.guess" cmake/ || die

	# Verify that the ebuild is up-to-date
	check_uptodate

	# create extra parent dir for relative CLANG_RESOURCE_DIR access
	mkdir -p x/y || die
	BUILD_DIR=${WORKDIR}/x/y/llvm

	llvm.org_src_prepare

	# add Gentoo Portage Prefix for Darwin (see prefix-dirs.patch)
	eprefixify \
		"${WORKDIR}/clang/lib/Lex/InitHeaderSearch.cpp" \
		"${WORKDIR}/clang/lib/Driver/ToolChains/Darwin.cpp" || die

	if ! use prefix-guest && [[ -n ${EPREFIX} ]]; then
		sed -i "/LibDir.*Loader/s@return \"\/\"@return \"${EPREFIX}/\"@" "${WORKDIR}/clang/lib/Driver/ToolChains/Linux.cpp" || die
	fi
}

get_distribution_components() {
	local sep=${1-;}

	local out=(
		# shared libs
		LLVM
		LTO
		Remarks

		# tools
		llvm-config

		# common stuff
		cmake-exports
		llvm-headers

		# libraries needed for clang-tblgen
		LLVMDemangle
		LLVMSupport
		LLVMTableGen

		# testing libraries
		llvm_gtest
		llvm_gtest_main
		LLVMTestingAnnotations
		LLVMTestingSupport
	)

	if use llvm_projects_clang; then
		out+=(
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
	fi

	if multilib_is_native_abi; then
		out+=(
			# utilities
			llvm-tblgen
			FileCheck
			llvm-PerfectShuffle
			count
			not
			yaml-bench
			UnicodeNameMappingGenerator

			# tools
			bugpoint
			dsymutil
			llc
			lli
			lli-child-target
			llvm-addr2line
			llvm-ar
			llvm-as
			llvm-bcanalyzer
			llvm-bitcode-strip
			llvm-c-test
			llvm-cat
			llvm-cfi-verify
			llvm-config
			llvm-cov
			llvm-cvtres
			llvm-cxxdump
			llvm-cxxfilt
			llvm-cxxmap
			llvm-debuginfo-analyzer
			llvm-debuginfod
			llvm-debuginfod-find
			llvm-diff
			llvm-dis
			llvm-dlltool
			llvm-dwarfdump
			llvm-dwarfutil
			llvm-dwp
			llvm-exegesis
			llvm-extract
			llvm-gsymutil
			llvm-ifs
			llvm-install-name-tool
			llvm-jitlink
			llvm-jitlink-executor
			llvm-lib
			llvm-libtool-darwin
			llvm-link
			llvm-lipo
			llvm-lto
			llvm-lto2
			llvm-mc
			llvm-mca
			llvm-ml
			llvm-modextract
			llvm-mt
			llvm-nm
			llvm-objcopy
			llvm-objdump
			llvm-opt-report
			llvm-otool
			llvm-pdbutil
			llvm-profdata
			llvm-profgen
			llvm-ranlib
			llvm-rc
			llvm-readelf
			llvm-readobj
			llvm-readtapi
			llvm-reduce
			llvm-remarkutil
			llvm-rtdyld
			llvm-sim
			llvm-size
			llvm-split
			llvm-stress
			llvm-strings
			llvm-strip
			llvm-symbolizer
			llvm-tli-checker
			llvm-undname
			llvm-windres
			llvm-xray
			obj2yaml
			opt
			sancov
			sanstats
			split-file
			verify-uselistorder
			yaml2obj

			# python modules
			opt-viewer
		)

		if use llvm_projects_clang; then
			out+=(
				# common stuff
				bash-autocomplete
				libclang-python-bindings

				# tools
				amdgpu-arch
				c-index-test
				clang
				clang-format
				clang-linker-wrapper
				clang-offload-bundler
				clang-offload-packager
				clang-refactor
				clang-repl
				clang-rename
				clang-scan-deps
				diagtool
				hmaptool
				nvptx-arch

				# needed for cross-compiling Clang
				clang-tblgen
			)
		fi

		if use llvm_projects_clang-tools-extra; then
			out+=(
				# extra tools
				clang-apply-replacements
				clang-change-namespace
				clang-doc
				clang-include-cleaner
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

		if use llvm_projects_lld; then
			out+=(
				lld-cmake-exports
				lld
			)
		fi

		if llvm_are_manpages_built; then
			out+=(
				# manpages
				docs-dsymutil-man
				docs-llvm-dwarfdump-man
				docs-llvm-man
			)

			if use llvm_projects_clang; then
				out+=( docs-clang-man )
			fi

			if use llvm_projects_clang-tools-extra; then
				out+=( docs-clang-tools-man )
			fi
		fi

		if use doc; then
			out+=( docs-llvm-html )

			if use llvm_projects_clang; then
				out+=( docs-clang-html )
			fi

			if use llvm_projects_clang-tools-extra; then
				out+=( docs-clang-tools-html )
			fi

			if use llvm_projects_lld; then
				out+=( docs-lld-html )
			fi
		fi

		use binutils-plugin && out+=(
			LLVMgold
		)
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
	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
	fi

	local ENABLE_PROJECTS="${LLVM_PROJECTS// /;}"
	if ! multilib_is_native_abi; then
		# Disable projects that are only relevant with native ABI
		ENABLE_PROJECTS="${ENABLE_PROJECTS//;lld/}"
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_ENABLE_PROJECTS="${ENABLE_PROJECTS}"

		# disable appending VCS revision to the version to improve
		# direct cache hit ratio
		-DLLVM_APPEND_VC_REV=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)

		# cheap hack: LLVM combines both anyway, and the only difference
		# is that the former list is explicitly verified at cmake time
		-DLLVM_TARGETS_TO_BUILD=""
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_INCLUDE_BENCHMARKS=OFF
		-DLLVM_INCLUDE_TESTS=ON
		-DLLVM_BUILD_TESTS=$(usex test)
		-DLLVM_INSTALL_GTEST=ON

		-DLLVM_ENABLE_FFI=$(usex libffi)
		-DLLVM_ENABLE_LIBEDIT=$(usex libedit)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLVM_ENABLE_LIBXML2=$(usex xml)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_LIBPFM=$(usex exegesis)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_Z3_SOLVER=$(usex z3)
		-DLLVM_ENABLE_ZSTD=$(usex zstd)
		-DLLVM_ENABLE_CURL=$(usex debuginfod)
		-DLLVM_ENABLE_HTTPLIB=$(usex debuginfod)

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DFFI_INCLUDE_DIR="${ffi_cflags#-I}"
		-DFFI_LIBRARY_DIR="${ffi_ldflags#-L}"
		# used only for llvm-objdump tool
		-DLLVM_HAVE_LIBXAR=$(multilib_native_usex xar 1 0)

		-DPython3_EXECUTABLE="${PYTHON}"

		# disable OCaml bindings (now in dev-ml/llvm-ocaml)
		-DOCAMLFIND=NO
	)

	local suffix=
	if [[ -n ${EGIT_VERSION} && ${EGIT_BRANCH} != release/* ]]; then
		# the ABI of the main branch is not stable, so let's include
		# the commit id in the SOVERSION to contain the breakage
		suffix+="git${EGIT_VERSION::8}"
	fi
	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		# Smart hack: alter version suffix -> SOVERSION when linking
		# against libc++. This way we won't end up mixing LLVM libc++
		# libraries with libstdc++ clang, and the other way around.
		suffix+="+libcxx"
		mycmakeargs+=(
			-DLLVM_ENABLE_LIBCXX=ON
		)
	fi
	mycmakeargs+=(
		-DLLVM_VERSION_SUFFIX="${suffix}"
	)

	if use llvm_projects_clang; then
		mycmakeargs+=(
			-DDEFAULT_SYSROOT=$(usex prefix-guest "" "${EPREFIX}")
			-DCLANG_CONFIG_FILE_SYSTEM_DIR="${EPREFIX}/etc/clang"
			# relative to bindir
			-DCLANG_RESOURCE_DIR="../../../../lib/clang/${LLVM_MAJOR}"
			-DCLANG_INCLUDE_TESTS=$(usex test)

			# libgomp support fails to find headers without explicit -I
			# furthermore, it provides only syntax checking
			-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

			-DCLANG_DEFAULT_PIE_ON_LINUX=$(usex pie)

			-DCLANG_ENABLE_LIBXML2=$(usex xml)
			-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
			-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)
			# TODO: CLANG_ENABLE_HLSL?
		)
	fi

	use test && mycmakeargs+=(
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	if multilib_is_native_abi; then
		local build_docs=OFF
		if llvm_are_manpages_built; then
			build_docs=ON
			mycmakeargs+=(
				-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
				-DLLVM_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
				-DSPHINX_WARNINGS_AS_ERRORS=OFF
			)

			if use llvm_projects_clang; then
				mycmakeargs+=(
					-DCLANG_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
				)
			fi

			if use llvm_projects_clang-tools-extra; then
				mycmakeargs+=(
					-DCLANG-TOOLS_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/tools-extra"
				)
			fi
		fi

		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=${build_docs}
			-DLLVM_ENABLE_OCAMLDOC=OFF
			-DLLVM_ENABLE_SPHINX=${build_docs}
			-DLLVM_ENABLE_DOXYGEN=OFF
			-DLLVM_INSTALL_UTILS=ON
		)
		use binutils-plugin && mycmakeargs+=(
			-DLLVM_BINUTILS_INCDIR="${EPREFIX}"/usr/include
		)

		if use llvm_projects_clang; then
			mycmakeargs+=(
				-DCLANG_INCLUDE_DOCS=${build_docs}
			)
		fi

		if use llvm_projects_clang-tools-extra; then
			mycmakeargs+=(
				-DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=${build_docs}
			)
		fi

		if [[ -n "${LLVM_SANITIZERS}" ]]; then
			want_sanitizer=ON
		fi
	fi

	# workaround BMI bug in gcc-7 (fixed in 7.4)
	# https://bugs.gentoo.org/649880
	# apply only to x86, https://bugs.gentoo.org/650506
	if tc-is-gcc && [[ ${MULTILIB_ABI_FLAG} == abi_x86* ]] &&
			[[ $(gcc-major-version) -eq 7 && $(gcc-minor-version) -lt 4 ]]
	then
		local CFLAGS="${CFLAGS} -mno-bmi"
		local CXXFLAGS="${CXXFLAGS} -mno-bmi"
	fi

	if use llvm_projects_clang; then
		if [[ -n ${EPREFIX} ]]; then
			mycmakeargs+=(
				-DGCC_INSTALL_PREFIX="${EPREFIX}/usr"
			)
		fi

		if tc-is-cross-compiler; then
			has_version -b sys-devel/clang:${LLVM_MAJOR} ||
				die "sys-devel/llvm:${LLVM_MAJOR}[llvm_projects_clang] is required on the build host."
			local tools_bin=${BROOT}/usr/lib/llvm/${LLVM_MAJOR}/bin
			mycmakeargs+=(
				-DLLVM_TOOLS_BINARY_DIR="${tools_bin}"
				-DCLANG_TABLEGEN="${tools_bin}"/clang-tblgen
			)
		fi
	fi

	# LLVM can have very high memory consumption while linking,
	# exhausting the limit on 32-bit linker executable
	use x86 && local -x LDFLAGS="${LDFLAGS} -Wl,--no-keep-memory"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure

	grep -q -E "^CMAKE_PROJECT_VERSION_MAJOR(:.*)?=${LLVM_MAJOR}$" \
			CMakeCache.txt ||
		die "Incorrect version, did you update _LLVM_MAIN_MAJOR?"
	multilib_is_native_abi && check_distribution_components
}

multilib_src_compile() {
	tc-env_build cmake_build distribution

	pax-mark m "${BUILD_DIR}"/bin/llvm-rtdyld
	pax-mark m "${BUILD_DIR}"/bin/lli
	pax-mark m "${BUILD_DIR}"/bin/lli-child-target

	if use test; then
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/Orc/OrcJITTests
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/MCJIT/MCJITTests
		pax-mark m "${BUILD_DIR}"/unittests/Support/SupportTests
	fi
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	local test_targets=( check )

	if use llvm_projects_clang; then
		test_targets+=( check-clang )
	fi

	if multilib_native_use llvm_projects_clang-tools-extra; then
		test_targets+=(
			check-clang-tools
			check-clangd
		)
	fi

	if multilib_native_use llvm_projects_lld; then
		test_targets+=( check-lld )
	fi

	cmake_build "${test_targets[@]}"
}

src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/lib/llvm/${LLVM_MAJOR}/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/llvm-config.h
	)

	if use llvm_projects_clang; then
		MULTILIB_WRAPPED_HEADERS+=(
			/usr/include/clang/Config/config.h
		)
	fi

	local LLVM_LDPATHS=()
	multilib-minimal_src_install

	# Move runtime headers to /usr/lib/clang, where they belong
	mv "${ED}"/usr/include/clangrt "${ED}"/usr/lib/clang || die

	# move (remaining) wrapped headers back
	if use llvm_projects_clang-tools-extra; then
		mv "${T}"/clang-tidy "${ED}"/usr/include/ || die
	fi
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include || die

	if use llvm_projects_clang; then
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
			dosym  "clang-${LLVM_MAJOR}" "/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}-${LLVM_MAJOR}"
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
	fi
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install-distribution

	# move headers to /usr/include for wrapping & ABI mismatch checks
	# (also drop the version suffix from runtime headers)
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include "${ED}"/usr/include || die

	if use llvm_projects_clang; then
		mv "${ED}"/usr/lib/clang "${ED}"/usr/include/clangrt || die
	fi

	if multilib_native_use llvm_projects_clang-tools-extra; then
		# don't wrap clang-tidy headers, the list is too long
		# (they're fine for non-native ABI but enabling the targets is problematic)
		mv "${ED}"/usr/include/clang-tidy "${T}/" || die
	fi

	LLVM_LDPATHS+=( "${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)" )
}

multilib_src_install_all() {
	local revord=$(( 9999 - ${LLVM_MAJOR} ))
	newenvd - "60llvm-${revord}" <<-_EOF_
		PATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin"
		MANPATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
		LDPATH="$( IFS=:; echo "${LLVM_LDPATHS[*]}" )"
	_EOF_

	if use llvm_projects_clang; then
		python_fix_shebang "${ED}"
	fi

	if use static-analyzer; then
		python_optimize "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/share/scan-view
	fi

	docompress "/usr/lib/llvm/${LLVM_MAJOR}/share/man"
	llvm_install_manpages

	if use llvm_projects_clang-tools-extra; then
		# match 'html' non-compression
		use doc && docompress -x "/usr/share/doc/${PF}/tools-extra"
	fi
	# +x for some reason; TODO: investigate
	use static-analyzer && fperms a-x "/usr/lib/llvm/${LLVM_MAJOR}/share/man/man1/scan-build.1"
}

pkg_postinst() {
	elog "You can find additional opt-viewer utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/opt-viewer"
	elog "To use these scripts, you will need Python along with the following"
	elog "packages:"
	elog "  dev-python/pygments (for opt-viewer)"
	elog "  dev-python/pyyaml (for all of them)"

	if use llvm_projects_clang; then
		if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
			eselect compiler-shadow update all
		fi

		elog "You can find additional utility scripts in:"
		elog "  ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/clang"
		if use llvm_projects_clang-tools-extra; then
			elog "Some of them are vim integration scripts (with instructions inside)."
			elog "The run-clang-tidy.py script requires the following additional package:"
			elog "  dev-python/pyyaml"
		fi
	fi
}

pkg_postrm() {
	if use llvm_projects_clang; then
		if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
			eselect compiler-shadow clean all
		fi
	fi
}
