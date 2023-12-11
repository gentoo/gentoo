# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm-toolchain.eclass
# @MAINTAINER:
# Violet Purcell <vimproved@inventati.org>
# @AUTHOR:
# Violet Purcell <vimproved@inventati.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common code for sys-devel/llvm ebuilds
# @DESCRIPTION:
# Common code for sys-devel/llvm euilds. If depending on LLVM, please use
# llvm.eclass. If using the LLVM Project source, please use llvm.org.eclass.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_LLVM_TOOLCHAIN_ECLASS} ]]; then
_LLVM_TOOLCHAIN_ECLASS=1

DESCRIPTION="The LLVM collection of modular compiler and toolchain components"
HOMEPAGE="https://llvm.org/"

inherit cmake crossdev llvm.org multilib-minimal pax-utils prefix
inherit python-single-r1 toolchain-funcs

#---->> globals <<----

# @ECLASS_VARIABLE: LLVM_USE_PROJECTS
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Bash array of LLVM_PROJECTS values to enable for this version.

# @FUNCTION: llvm_project_available
# @INTERNAL
# @DESCRIPTION:
# Return 0 if project in is IUSE, return 1 if not.
llvm_project_available() {
	[[ "${IUSE}" = *" llvm_projects_${1}"* ]]
}

# @FUNCTION: llvm_project_enabled
# @INTERNAL
# @DESCRIPTION:
# Safely determine if a project is enabled, returning 1 if it is not in IUSE.
llvm_project_enabled() {
	project="$1"
	llvm_project_available "${project}" || return 1
	use "llvm_projects_${project}"
}

# ---->> LICENSE+SLOT+IUSE logic <<----

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD public-domain rc"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="+binutils-plugin debug debuginfod doc exegesis libedit +libffi ncurses test xml z3 zstd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

ver_test "${PV}" -lt 18 && IUSE+=" xar"

if [[ $(declare -p LLVM_USE_PROJECTS) != "declare -a"* ]]; then
	die 'LLVM_USE_PROJECTS must be an array.'
fi

for project in "${LLVM_USE_PROJECTS[@]}"; do
	IUSE+=" llvm_projects_${project}"
done

if llvm_project_available clang; then
	LICENSE+=" llvm_projects_clang? ( MIT )"
	IUSE+=" ieee-long-double +pie +static-analyzer"
	REQUIRED_USE+=" static-analyzer? ( llvm_projects_clang )"
fi

if llvm_project_available clang-tools-extra; then
	llvm_project_available clang || die "clang-tools-extra requires clang to be in LLVM_USE_PROJECTS"
	REQUIRED_USE+=" llvm_projects_clang-tools-extra? ( llvm_projects_clang )"
fi

# ---->> DEPEND <<----

RDEPEND="
	${PYTHON_DEPS}
	sys-libs/zlib:0=[${MULTILIB_USEDEP}]
	debuginfod? (
		net-misc/curl:=
		dev-cpp/cpp-httplib:=
	)
	exegesis? ( dev-libs/libpfm:= )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=dev-libs/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	z3? ( >=sci-mathematics/z3-4.7.1:0=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"

ver_test "${PV}" -lt 18 && RDEPEND+=" xar? ( app-arch/xar )"

# There are no file collisions between these versions but having :0
# installed means llvm-config there will take precedence.
RDEPEND+=" !sys-devel/llvm:0"

# Blockers for split ebuilds in ::gentoo
case ${LLVM_MAJOR} in
	17)
		RDEPEND+="
			llvm_projects_clang? ( !<sys-devel/clang-17.0.6-r1:17 )
			llvm_projects_lld? ( !<sys-devel/lld-17.0.6-r1:17 )
		"
		;;
	18)
		RDEPEND+="
			llvm_projects_clang? ( !<sys-devel/clang-18.0.0_pre20231129-r1 )
			llvm_projects_lld? ( !<sys-devel/lld-18.0.0_pre20231129-r1 )
		"
		;;
esac

DEPEND="
	${RDEPEND}
	binutils-plugin? ( sys-libs/binutils-libs )
"

if ver_test "${PV}" -lt 18; then
	COMMONMARK_DEP='dev-python/recommonmark'
else
	COMMONMARK_DEP='dev-python/myst-parser'
fi

BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	>=dev-util/cmake-3.16
	sys-devel/gnuconfig
	kernel_Darwin? (
		<sys-libs/libcxx-${LLVM_VERSION}.9999
		>=sys-devel/binutils-apple-5.1
	)
	doc? ( $(python_gen_cond_dep "
		${COMMONMARK_DEP}[\${PYTHON_USEDEP}]
		dev-python/sphinx[\${PYTHON_USEDEP}]
	") )
	libffi? ( virtual/pkgconfig )
"

PDEPEND="
	sys-devel/llvm-common
	sys-devel/llvm-toolchain-symlinks:${LLVM_MAJOR}
	binutils-plugin? ( >=sys-devel/llvmgold-${LLVM_MAJOR} )
"


if llvm_project_available clang; then
	DEPEND+="
		llvm_projects_clang? (
			static-analyzer? ( dev-lang/perl:* )
			xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
		)
	"
	RDEPEND+=" llvm_projects_clang? ( >=sys-devel/clang-common-${PV} )"
	BDEPEND+=" llvm_projects_clang? ( xml? ( virtual/pkgconfig ) )"
	PDEPEND+="
		llvm_projects_clang? (
			~sys-devel/clang-runtime-${PV}
			sys-devel/clang-toolchain-symlinks:${LLVM_MAJOR}
		)
	"
fi

if llvm_project_available lld; then
	PDEPEND+=" llvm_projects_lld? ( >=sys-devel/lld-toolchain-symlinks-16-r2:${LLVM_MAJOR} )"
fi

# @ECLASS_VARIABLE: LLVM_COMPONENTS
# @INTERNAL
# @DESCRIPTION:
# LLVM_COMPONENTS value for llvm.org.eclass
LLVM_COMPONENTS=( llvm cmake third-party "${LLVM_USE_PROJECTS[@]}" )

# @ECLASS_VARIABLE: LLVM_MANPAGES
# @INTERNAL
# @DESCRIPTION:
# LLVM_MANPAGES value for llvm.org.eclass
LLVM_MANPAGES=1

# @ECLASS_VARIABLE: LLVM_USE_TARGETS
# @INTERNAL
# @DESCRIPTION:
# LLVM_USE_TARGETS value for llvm.org.eclass
LLVM_USE_TARGETS=provide

llvm.org_set_globals

#---->> pkg_setup <<----

# @FUNCTION: python_check_deps
# @INTERNAL
# @DESCRIPTION:
# Function to check python deps.
python_check_deps() {
	use doc || return 0

	python_has_version -b "${COMMONMARK_DEP}[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]"
}

#---->> src_prepare <<----

llvm-toolchain_src_prepare() {
	# create extra parent dir for relative CLANG_RESOURCE_DIR access
	mkdir -p x/y || die
	BUILD_DIR="${WORKDIR}/x/y/llvm"

	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	# Update config.guess to support more systems
	cp "${BROOT}/usr/share/gnuconfig/config.guess" cmake/ || die

	# Verify that the ebuild is up-to-date
	check_uptodate

	llvm.org_src_prepare

	if llvm_project_enabled clang; then
		# add Gentoo Portage Prefix for Darwin
		eprefixify "${WORKDIR}/clang/lib/Lex/InitHeaderSearch.cpp" \
			"${WORKDIR}/clang/lib/Driver/ToolChains/Darwin.cpp" || die

		if ! use prefix-guest && [[ -n ${EPREFIX} ]]; then
			sed -i "/LibDir.*Loader/s@return \"\/\"@return \"${EPREFIX}/\"@" \
				"${WORKDIR}/clang/lib/Driver/ToolChains/Linux.cpp" || die
		fi
	fi
}

#---->> src_configure <<----

# @FUNCTION: check_uptodate
# @INTERNAL
# @DESCRIPTION:
# Check that ALL_LLVM_EXPERIMENTAL_TARGETS and ALL_LLVM_PRODUCTION_TARGETS are
# up to date.
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

# @FUNCTION: check_distribution_components
# @INTERNAL
# @DESCRIPTION:
# Checks distribution components from get_distribution_components against all
# available distribution components.
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
					# only build w/ USE=debuginfod
					llvm-debuginfod)
						use debuginfod || continue
						;;
					# used only w/ USE=doc
					docs-clang-html|docs-clang-tools-html|docs-llvm-html)
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

# @FUNCTION: get_distribution_components
# @INTERNAL
# @DESCRIPTION:
# Returns a list of LLVM distribution components based on enabled use flags.
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

		ver_test "${PV}" -lt 18 && out+=(
			llvm-remark-size-diff
			llvm-tapi-diff
		)

		ver_test "${PV}" -ge 18 && out+=(
			llvm-readtapi
		)

		if llvm_are_manpages_built; then
			out+=(
				# manpages
				docs-dsymutil-man
				docs-llvm-dwarfdump-man
				docs-llvm-man
			)
		fi
		use doc && out+=(
			docs-llvm-html
		)

		use binutils-plugin && out+=(
			LLVMgold
		)
		use debuginfod && out+=(
			llvm-debuginfod
		)
	fi

	if llvm_project_enabled clang; then
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

		if multilib_is_native_abi; then
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

		if llvm_are_manpages_built; then
			out+=( docs-clang-man )
		fi

		if use doc; then
			out+=( docs-clang-html )
		fi

		use static-analyzer && out+=(
			clang-check
			clang-extdef-mapping
			scan-build
			scan-build-py
			scan-view
		)
	fi

	if llvm_project_enabled clang-tools-extra && multilib_is_native_abi; then
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

		if llvm_are_manpages_built; then
			out+=( docs-clang-tools-man )
		fi

		if use doc; then
			out+=( docs-clang-tools-html )
		fi
	fi

	if llvm_project_enabled lld && multilib_is_native_abi; then
		out+=(
			# common stuff
			lld-cmake-exports

			# tools
			lld
		)

		if use doc; then
			out+=( docs-lld-html )
		fi
	fi

	printf "%s${sep}" "${out[@]}"
}

# @FUNCTION: multilib_src_configure
# @INTERNAL
# @DESCRIPTION:
# src_configure function for multilib-minimal.eclass.
multilib_src_configure() {
	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_ENABLE_PROJECTS="llvm;${LLVM_PROJECTS// /;}"

		# disable appending VCS revision to the version to improve
		# direct cache hit ratio
		-DLLVM_APPEND_VC_REV=OFF
		-DDEFAULT_SYSROOT=$(usex prefix-guest "" "${EPREFIX}")
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_LINK_LLVM_DYLIB=ON
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

		-DPython3_EXECUTABLE="${PYTHON}"

		# disable OCaml bindings (now in dev-ml/llvm-ocaml)
		-DOCAMLFIND=NO
	)

	use elibc_musl && mycmakeargs+=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Backtrace=ON
	)

	ver_test "${PV}" -lt 18 && mycmakeargs+=(
		# used only for llvm-objdump tool
		-DLLVM_HAVE_LIBXAR=$(multilib_native_usex xar 1 0)
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
	fi

	# On Macos prefix, Gentoo doesn't split sys-libs/ncurses to libtinfo and
	# libncurses, but llvm tries to use libtinfo before libncurses, and ends up
	# using libtinfo (actually, libncurses.dylib) from system instead of prefix
	use kernel_Darwin && mycmakeargs+=(
		-DTerminfo_LIBRARIES=-lncurses
	)

	# workaround BMI bug in gcc-7 (fixed in 7.4)
	# https://bugs.gentoo.org/649880
	# apply only to x86, https://bugs.gentoo.org/650506
	if tc-is-gcc && [[ ${MULTILIB_ABI_FLAG} == abi_x86* ]] &&
			[[ $(gcc-major-version) -eq 7 && $(gcc-minor-version) -lt 4 ]]
	then
		local CFLAGS="${CFLAGS} -mno-bmi"
		local CXXFLAGS="${CXXFLAGS} -mno-bmi"
	fi

	if llvm_project_enabled clang; then
		mycmakeargs+=(
			-DCLANG_CONFIG_FILE_SYSTEM_DIR="${EPREFIX}/etc/clang"
			# relative to bindir
			-DCLANG_RESOURCE_DIR="../../../../lib/clang/${LLVM_MAJOR}"

			# libgomp support fails to find headers without explicit -I
			# furthermore, it provides only syntax checking
			-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

			# disable using CUDA to autodetect GPU, just build for all
			-DCMAKE_DISABLE_FIND_PACKAGE_CUDAToolkit=ON
			# disable linking to HSA to avoid automagic dep,
			# load it dynamically instead
			-DCMAKE_DISABLE_FIND_PACKAGE_hsa-runtime64=ON

			-DCLANG_DEFAULT_PIE_ON_LINUX=$(usex pie)

			-DCLANG_ENABLE_LIBXML2=$(usex xml)
			-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
			-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)
		)

		if ! use elibc_musl; then
			mycmakeargs+=(
				-DPPC_LINUX_DEFAULT_IEEELONGDOUBLE=$(usex ieee-long-double)
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
				-DLLVM_TOOLS_BINRAY_DIR="${tools_bin}"
				-DCLANG_TABLEGEN="${tools_bin}"/clang-tblgen
			)
		fi
	fi

	# LLVM can have very high memory consumption while linking,
	# exhausting the limit on 32-bit linker executable
	use x86 && local -x LDFLAGS="${LDFLAGS} -Wl,--no-keep-memory"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152
	cmake_src_configure

	grep -q -E "^CMAKE_PROJECT_VERSION_MAJOR(:.*)?=${LLVM_MAJOR}$" \
			CMakeCache.txt ||
		die "Incorrect version, did you update _LLVM_MAIN_MAJOR?"
	multilib_is_native_abi && check_distribution_components
}

#---->> src_compile <<----

# @FUNCTION: multilib_src_compile
# @INTERNAL
# @DESCRIPTION:
# src_compile function for multilib-minimal.eclass.
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

#---->> src_test <<----

# @FUNCTION: multilib_src_test
# @INTERNAL
# @DESCRIPTION:
# src_test function for multilib-minimal.eclass.
multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	local test_targets=( check )
	llvm_project_enabled clang && test_targets+=( check-clang )
	if multilib_is_native_abi; then
		llvm_project_enabled clang-tools-extra && test_targets+=(
			check-clang-tools
			check-clangd
		)
		llvm_project_enabled lld && test_targets+=( check-lld )
	fi
	cmake_build "${test_targets[@]}"
}

#---->> src_install <<----

# @FUNCTION: multilib_src_install
# @INTERNAL
# @DESCRIPTION:
# src_install function for multilib-minimal.eclass.
multilib_src_install() {
	DESTDIR=${D} cmake_build install-distribution

	# move headers to /usr/include for wrapping & ABI mismatch checks
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include "${ED}"/usr/include || die
	if llvm_project_enabled clang; then
		# (also drop the version suffix from runtime headers
		mv "${ED}"/usr/lib/clang "${ED}"/usr/include/clangrt || die
	fi

	if llvm_project_enabled clang-tools-extra; then
		# don't wrap clang-tidy headers, the list is too long
		# (they're fine for non-native ABI but enabling the targets is problematic)
		mv "${ED}"/usr/include/clang-tidy "${T}/" || die
	fi

	LLVM_LDPATHS+=( "${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)" )
}

# @FUNCTION: multilib_src_install_all
# @INTERNAL
# @DESCRIPTION:
# src_install function for multilib-minimal.eclass.
multilib_src_install_all() {
	python_fix_shebang "${ED}"
	local revord=$(( 9999 - ${LLVM_MAJOR} ))
	newenvd - "60llvm-${revord}" <<-_EOF_
		PATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin"
		MANPATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
		LDPATH="$( IFS=:; echo "${LLVM_LDPATHS[*]}" )"
	_EOF_

	if llvm_project_enabled clang; then
		if use static-analyzer; then
			python_optimize "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/share/scan-view
		fi
	fi

	docompress "/usr/lib/llvm/${LLVM_MAJOR}/share/man"
	llvm_install_manpages

	if llvm_project_enabled clang; then
		# +x for some reason; TODO: investigate
		use static-analyzer && fperms a-x "/usr/lib/llvm/${LLVM_MAJOR}/share/man/man1/scan-build.1"
	fi
}

llvm-toolchain_src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/lib/llvm/${LLVM_MAJOR}/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/llvm-config.h
	)

	llvm_project_enabled clang && MULTILIB_WRAPPED_HEADERS+=(
		/usr/include/clang/Config/config.h
	)

	local LLVM_LDPATHS=()
	multilib-minimal_src_install

	if llvm_project_enabled clang; then
		# Move runtime headers to /usr/lib/clang, where they belong
		mv "${ED}"/usr/include/clangrt "${ED}"/usr/lib/clang || die
	fi
	# move (remaining) wrapped headers back
	if llvm_project_enabled clang-tools-extra; then
		mv "${T}"/clang-tidy "${ED}"/usr/include
	fi
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include || die

	if llvm_project_enabled clang; then
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

#---->> pkg_postinst <<----

llvm-toolchain_pkg_postinst() {
	elog "You can find additional opt-viewer utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/opt-viewer"
	elog "To use these scripts, you will need Python along with the following"
	elog "packages:"
	elog "  dev-python/pygments (for opt-viewer)"
	elog "  dev-python/pyyaml (for all of them)"
	if llvm_project_enabled clang; then
		if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
			eselect compiler-shadow update all
		fi

		elog "You can find additional utility scripts in:"
		elog " ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/clang"
	fi
	if llvm_project_enabled clang-tools-extra; then
		elog "Some of them are vim integration scripts (with instructions inside)."
		elog "The run-clang-tidy.py script requires the following additional package:"
		elog "  dev-python/pyyaml"
	fi
}

#---->> pkg_postrm <<----

llvm-toolchain_pkg_postrm() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi
}

fi

EXPORT_FUNCTIONS src_prepare src_install pkg_postinst pkg_postrm
