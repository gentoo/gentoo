# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake flag-o-matic llvm.org multilib-minimal pax-utils python-any-r1
inherit toolchain-funcs

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="https://llvm.org/"

# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. xxhash: BSD.
# 3. MD5 code: public-domain.
# 4. ConvertUTF.h: TODO.

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD public-domain rc"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="
	+binutils-plugin +debug debuginfod doc exegesis libedit +libffi
	test xml z3 zstd
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
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	z3? ( >=sci-mathematics/z3-4.7.1:0=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	binutils-plugin? ( sys-libs/binutils-libs )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	sys-devel/gnuconfig
	kernel_Darwin? (
		<llvm-runtimes/libcxx-${LLVM_VERSION}.9999
	)
	libffi? ( virtual/pkgconfig )
"
# There are no file collisions between these versions but having :0
# installed means llvm-config there will take precedence.
RDEPEND="
	${RDEPEND}
	!llvm-core/llvm:0
"
PDEPEND="
	llvm-core/llvm-common
	llvm-core/llvm-toolchain-symlinks:${LLVM_MAJOR}
	binutils-plugin? ( >=llvm-core/llvmgold-${LLVM_MAJOR} )
"

LLVM_COMPONENTS=( llvm cmake third-party )
LLVM_MANPAGES=1
LLVM_USE_TARGETS=provide
llvm.org_set_globals

[[ -n ${LLVM_MANPAGE_DIST} ]] && BDEPEND+=" doc? ( "
BDEPEND+="
	$(python_gen_any_dep '
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	')
"
[[ -n ${LLVM_MANPAGE_DIST} ]] && BDEPEND+=" ) "

python_check_deps() {
	llvm_are_manpages_built || return 0

	python_has_version -b "dev-python/myst-parser[${PYTHON_USEDEP}]" &&
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

	local outdated
	if [[ ${exp_targets[*]} != ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]} ]]; then
		eerror "ALL_LLVM_EXPERIMENTAL_TARGETS are outdated!"
		eerror "    Have: ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]}"
		eerror "Expected: ${exp_targets[*]}"
		eerror
		outdated=1
	fi

	if [[ ${prod_targets[*]} != ${ALL_LLVM_PRODUCTION_TARGETS[*]} ]]; then
		eerror "ALL_LLVM_PRODUCTION_TARGETS are outdated!"
		eerror "    Have: ${ALL_LLVM_PRODUCTION_TARGETS[*]}"
		eerror "Expected: ${prod_targets[*]}"
		outdated=1
	fi

	[[ ${outdated} ]] && die "Update ALL_LLVM*_TARGETS"
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
					# for mlir-tblgen
					LLVMCodeGenTypes)
						;;
					# used by lldb
					LLVMDebuginfod)
						;;
					# testing libraries
					LLVMTestingAnnotations|LLVMTestingSupport)
						;;
					# static libs
					LLVM*)
						continue
						;;
					# meta-targets
					distribution|llvm-libraries)
						continue
						;;
					# used only w/ USE=doc
					docs-llvm-html)
						use doc || continue
						;;
					# used only w/ USE=debuginfd
					llvm-debuginfod)
						use debuginfod || continue
						;;
					# used only w/ USE=xml
					llvm-mt)
						use xml || continue
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
			eerror "get_distribution_components() is outdated!"
			eerror "   Add: ${add[*]}"
			eerror "Remove: ${remove[*]}"
			die "Update get_distribution_components()!"
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

	llvm.org_src_prepare
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
		# mlir-tblgen
		LLVMCodeGenTypes

		# testing libraries
		llvm_gtest
		llvm_gtest_main
		LLVMTestingAnnotations
		LLVMTestingSupport
	)

	if multilib_is_native_abi; then
		out+=(
			# library used by lldb
			LLVMDebuginfod

			# utilities
			llvm-tblgen
			llvm-test-mustache-spec
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
			llvm-cgdata
			llvm-config
			llvm-cov
			llvm-ctxprof-util
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
			llvm-ml64
			llvm-modextract
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
			reduce-chunk-list
			sancov
			sanstats
			split-file
			verify-uselistorder
			yaml2obj

			# python modules
			opt-viewer
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
		use xml && out+=(
			llvm-mt
		)
	fi

	printf "%s${sep}" "${out[@]}"
}

multilib_src_configure() {
	# ODR violations (bug #917536, bug #926529). Just do it for GCC for now
	# to avoid people grumbling. GCC is, anecdotally, more likely to miscompile
	# LLVM with LTO anyway (which is not necessarily its fault).
	tc-is-gcc && filter-lto

	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		# disable appending VCS revision to the version to improve
		# direct cache hit ratio
		-DLLVM_APPEND_VC_REV=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
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
		-DLLVM_ENABLE_LIBXML2=$(usex xml)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_LIBPFM=$(usex exegesis)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_Z3_SOLVER=$(usex z3)
		-DLLVM_ENABLE_ZLIB=FORCE_ON
		-DLLVM_ENABLE_ZSTD=$(usex zstd FORCE_ON OFF)
		-DLLVM_ENABLE_CURL=$(usex debuginfod)
		-DLLVM_ENABLE_HTTPLIB=$(usex debuginfod)

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DPython3_EXECUTABLE="${PYTHON}"

		# disable OCaml bindings (now in dev-ml/llvm)
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

	use kernel_Darwin && mycmakeargs+=(
		# Use our libtool instead of looking it up with xcrun
		-DCMAKE_LIBTOOL="${EPREFIX}/usr/bin/${CHOST}-libtool"
	)

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
	local -x LIT_XFAIL="CodeGen/Xtensa/select-cc-fp.ll"
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check
}

src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/lib/llvm/${LLVM_MAJOR}/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/llvm-config.h
	)

	local LLVM_LDPATHS=()
	multilib-minimal_src_install

	# move wrapped headers back
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include || die
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install-distribution

	# move headers to /usr/include for wrapping
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include "${ED}"/usr/include || die

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

	docompress "/usr/lib/llvm/${LLVM_MAJOR}/share/man"
	llvm_install_manpages
}

pkg_postinst() {
	elog "You can find additional opt-viewer utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/opt-viewer"
	elog "To use these scripts, you will need Python along with the following"
	elog "packages:"
	elog "  dev-python/pygments (for opt-viewer)"
	elog "  dev-python/pyyaml (for all of them)"
}
