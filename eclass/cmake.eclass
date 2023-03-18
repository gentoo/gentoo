# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cmake.eclass
# @MAINTAINER:
# kde@gentoo.org
# base-system@gentoo.org
# @AUTHOR:
# Tomáš Chvátal <scarabeus@gentoo.org>
# Maciej Mrozowski <reavertm@gentoo.org>
# (undisclosed contributors)
# Original author: Zephyrus (zephyrus@mirach.it)
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: ninja-utils
# @BLURB: common ebuild functions for cmake-based packages
# @DESCRIPTION:
# The cmake eclass makes creating ebuilds for cmake-based packages much easier.
# It provides all inherited features (DOCS, HTML_DOCS, PATCHES) along with
# out-of-source builds (default) and in-source builds.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CMAKE_ECLASS} ]]; then
_CMAKE_ECLASS=1

inherit flag-o-matic multiprocessing ninja-utils toolchain-funcs xdg-utils

# @ECLASS_VARIABLE: BUILD_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# Build directory where all cmake processed files should be generated.
# For in-source build it's fixed to ${CMAKE_USE_DIR}.
# For out-of-source build it can be overridden, by default it uses
# ${CMAKE_USE_DIR}_build (in EAPI-7: ${WORKDIR}/${P}_build).
[[ ${EAPI} == 7 ]] && : ${BUILD_DIR:=${WORKDIR}/${P}_build}
# EAPI-8: set inside _cmake_check_build_dir

# @ECLASS_VARIABLE: CMAKE_BINARY
# @DESCRIPTION:
# Eclass can use different cmake binary than the one provided in by system.
: ${CMAKE_BINARY:=cmake}

[[ ${EAPI} == 7 ]] && : ${CMAKE_BUILD_TYPE:=Gentoo}
# @ECLASS_VARIABLE: CMAKE_BUILD_TYPE
# @DESCRIPTION:
# Set to override default CMAKE_BUILD_TYPE. Only useful for packages
# known to make use of "if (CMAKE_BUILD_TYPE MATCHES xxx)".
# If about to be set - needs to be set before invoking cmake_src_configure.
#
# The default is RelWithDebInfo as that is least likely to append undesirable
# flags. However, you may still need to sed CMake files or choose a different
# build type to achieve desirable results.
#
# In EAPI 7, the default was non-standard build type of Gentoo.
: ${CMAKE_BUILD_TYPE:=RelWithDebInfo}

# @ECLASS_VARIABLE: CMAKE_IN_SOURCE_BUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to enable in-source build.

# @ECLASS_VARIABLE: CMAKE_MAKEFILE_GENERATOR
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specify a makefile generator to be used by cmake.
# At this point only "emake" and "ninja" are supported.
# The default is set to "ninja".
: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

# @ECLASS_VARIABLE: CMAKE_REMOVE_MODULES_LIST
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of .cmake modules to be removed in ${CMAKE_USE_DIR} (in EAPI-7: ${S})
# during src_prepare, in order to force packages to use the system version.
# By default, contains "FindBLAS" and "FindLAPACK".
# Set to empty to disable removing modules entirely.
if [[ ${CMAKE_REMOVE_MODULES_LIST} ]]; then
	if [[ ${EAPI} != 7 ]]; then
		[[ ${CMAKE_REMOVE_MODULES_LIST@a} == *a* ]] ||
			die "CMAKE_REMOVE_MODULES_LIST must be an array"
	fi
else
	if ! [[ ${CMAKE_REMOVE_MODULES_LIST@a} == *a* && ${#CMAKE_REMOVE_MODULES_LIST[@]} -eq 0 ]]; then
		CMAKE_REMOVE_MODULES_LIST=( FindBLAS FindLAPACK )
	fi
fi

# @ECLASS_VARIABLE: CMAKE_USE_DIR
# @DESCRIPTION:
# Sets the directory where we are working with cmake, for example when
# application uses autotools and only one plugin needs to be done by cmake.
# By default it uses current working directory (in EAPI-7: ${S}).

# @ECLASS_VARIABLE: CMAKE_VERBOSE
# @USER_VARIABLE
# @DESCRIPTION:
# Set to OFF to disable verbose messages during compilation
: ${CMAKE_VERBOSE:=ON}

# @ECLASS_VARIABLE: CMAKE_WARN_UNUSED_CLI
# @DESCRIPTION:
# Warn about variables that are declared on the command line
# but not used. Might give false-positives.
# "no" to disable (default) or anything else to enable.
: ${CMAKE_WARN_UNUSED_CLI:=yes}

# @ECLASS_VARIABLE: CMAKE_EXTRA_CACHE_FILE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specifies an extra cache file to pass to cmake. This is the analog of EXTRA_ECONF
# for econf and is needed to pass TRY_RUN results when cross-compiling.
# Should be set by user in a per-package basis in /etc/portage/package.env.

# @ECLASS_VARIABLE: CMAKE_QA_SRC_DIR_READONLY
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# After running cmake_src_prepare, sets ${CMAKE_USE_DIR} (in EAPI-7: ${S}) to
# read-only. This is a user flag and should under _no circumstances_ be set in
# the ebuild. Helps in improving QA of build systems that write to source tree.

[[ ${CMAKE_MIN_VERSION} ]] && die "CMAKE_MIN_VERSION is banned; if necessary, set BDEPEND=\">=dev-util/cmake-${CMAKE_MIN_VERSION}\" directly"
[[ ${CMAKE_BUILD_DIR} ]] && die "The ebuild must be migrated to BUILD_DIR"
[[ ${CMAKE_REMOVE_MODULES} ]] && die "CMAKE_REMOVE_MODULES is banned, set CMAKE_REMOVE_MODULES_LIST array instead"
[[ ${CMAKE_UTILS_QA_SRC_DIR_READONLY} ]] && die "Use CMAKE_QA_SRC_DIR_READONLY instead"
[[ ${WANT_CMAKE} ]] && die "WANT_CMAKE has been removed and is a no-op"
[[ ${PREFIX} ]] && die "PREFIX has been removed and is a no-op"

case ${CMAKE_MAKEFILE_GENERATOR} in
	emake)
		BDEPEND="sys-devel/make"
		;;
	ninja)
		BDEPEND="${NINJA_DEPEND}"
		;;
	*)
		eerror "Unknown value for \${CMAKE_MAKEFILE_GENERATOR}"
		die "Value ${CMAKE_MAKEFILE_GENERATOR} is not supported"
		;;
esac

if [[ ${PN} != cmake ]]; then
	BDEPEND+=" >=dev-util/cmake-3.20.5"
fi

# @FUNCTION: cmake_run_in
# @USAGE: <working dir> <run command>
# @DESCRIPTION:
# Set the desired working dir for a function or command.
cmake_run_in() {
	if [[ -z ${2} ]]; then
		die "${FUNCNAME[0]} must be passed at least two arguments"
	fi

	[[ -e ${1} ]] || die "${FUNCNAME[0]}: Nonexistent path: ${1}"

	pushd ${1} > /dev/null || die
		"${@:2}"
	popd > /dev/null || die
}

# @FUNCTION: cmake_comment_add_subdirectory
# @USAGE: <subdirectory>
# @DESCRIPTION:
# Comment out one or more add_subdirectory calls in CMakeLists.txt in the current directory
cmake_comment_add_subdirectory() {
	if [[ -z ${1} ]]; then
		die "${FUNCNAME[0]} must be passed at least one directory name to comment"
	fi

	[[ -e "CMakeLists.txt" ]] || return

	local d
	for d in $@; do
		d=${d//\//\\/}
		sed -e "/add_subdirectory[[:space:]]*([[:space:]]*${d}[[:space:]]*)/I s/^/#DONOTCOMPILE /" \
			-i CMakeLists.txt || die "failed to comment add_subdirectory(${d})"
	done
}

# @FUNCTION: comment_add_subdirectory
# @INTERNAL
# @DESCRIPTION:
# Banned. Use cmake_comment_add_subdirectory instead.
comment_add_subdirectory() {
	die "comment_add_subdirectory is banned. Use cmake_comment_add_subdirectory instead"
}

# @FUNCTION: cmake_use_find_package
# @USAGE: <USE flag> <package name>
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake_use_find_package foo LibFoo` echoes -DCMAKE_DISABLE_FIND_PACKAGE_LibFoo=OFF
# if foo is enabled and -DCMAKE_DISABLE_FIND_PACKAGE_LibFoo=ON if it is disabled.
# This can be used to make find_package optional.
cmake_use_find_package() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ "$#" != 2 || -z $1 ]] ; then
		die "Usage: cmake_use_find_package <USE flag> <package name>"
	fi

	echo "-DCMAKE_DISABLE_FIND_PACKAGE_$2=$(use $1 && echo OFF || echo ON)"
}

# @FUNCTION: _cmake_banned_func
# @INTERNAL
# @DESCRIPTION:
# Banned functions are banned.
_cmake_banned_func() {
	die "${FUNCNAME[1]} is banned. use -D$1<related_CMake_variable>=\"\$(usex $2)\" instead"
}

# @FUNCTION: cmake-utils_use_with
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DWITH_FOO=$(usex foo) instead.
cmake-utils_use_with() { _cmake_banned_func WITH_ "$@" ; }

# @FUNCTION: cmake-utils_use_enable
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DENABLE_FOO=$(usex foo) instead.
cmake-utils_use_enable() { _cmake_banned_func ENABLE_ "$@" ; }

# @FUNCTION: cmake-utils_use_disable
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DDISABLE_FOO=$(usex !foo) instead.
cmake-utils_use_disable() { _cmake_banned_func DISABLE_ "$@" ; }

# @FUNCTION: cmake-utils_use_no
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DNO_FOO=$(usex !foo) instead.
cmake-utils_use_no() { _cmake_banned_func NO_ "$@" ; }

# @FUNCTION: cmake-utils_use_want
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DWANT_FOO=$(usex foo) instead.
cmake-utils_use_want() { _cmake_banned_func WANT_ "$@" ; }

# @FUNCTION: cmake-utils_use_build
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DBUILD_FOO=$(usex foo) instead.
cmake-utils_use_build() { _cmake_banned_func BUILD_ "$@" ; }

# @FUNCTION: cmake-utils_use_has
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DHAVE_FOO=$(usex foo) instead.
cmake-utils_use_has() { _cmake_banned_func HAVE_ "$@" ; }

# @FUNCTION: cmake-utils_use_use
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DUSE_FOO=$(usex foo) instead.
cmake-utils_use_use() { _cmake_banned_func USE_ "$@" ; }

# @FUNCTION: cmake-utils_use
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DFOO=$(usex foo) instead.
cmake-utils_use() { _cmake_banned_func "" "$@" ; }

# @FUNCTION: cmake-utils_useno
# @INTERNAL
# @DESCRIPTION:
# Banned. Use -DNOFOO=$(usex !foo) instead.
cmake-utils_useno() { _cmake_banned_func "" "$@" ; }

# @FUNCTION: _cmake_check_build_dir
# @INTERNAL
# @DESCRIPTION:
# Determine using IN or OUT source build
_cmake_check_build_dir() {
	if [[ ${EAPI} == 7 ]]; then
		: ${CMAKE_USE_DIR:=${S}}
	else
		: ${CMAKE_USE_DIR:=${PWD}}
	fi
	if [[ -n ${CMAKE_IN_SOURCE_BUILD} ]]; then
		# we build in source dir
		BUILD_DIR="${CMAKE_USE_DIR}"
	else
		: ${BUILD_DIR:=${CMAKE_USE_DIR}_build}
	fi

	einfo "Source directory (CMAKE_USE_DIR): \"${CMAKE_USE_DIR}\""
	einfo "Build directory  (BUILD_DIR):     \"${BUILD_DIR}\""

	mkdir -p "${BUILD_DIR}" || die
}

# @FUNCTION: _cmake_modify-cmakelists
# @INTERNAL
# @DESCRIPTION:
# Internal function for modifying hardcoded definitions.
# Removes dangerous definitions that override Gentoo settings.
_cmake_modify-cmakelists() {
	debug-print-function ${FUNCNAME} "$@"

	# Only edit the files once
	grep -qs "<<< Gentoo configuration >>>" "${CMAKE_USE_DIR}"/CMakeLists.txt && return 0

	# Comment out all set (<some_should_be_user_defined_variable> value)
	find "${CMAKE_USE_DIR}" -name CMakeLists.txt -exec sed \
		-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_BUILD_TYPE\([[:space:]].*)\|)\)/I{s/^/#_cmake_modify_IGNORE /g}' \
		-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_COLOR_MAKEFILE[[:space:]].*)/I{s/^/#_cmake_modify_IGNORE /g}' \
		-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_INSTALL_PREFIX[[:space:]].*)/I{s/^/#_cmake_modify_IGNORE /g}' \
		-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_VERBOSE_MAKEFILE[[:space:]].*)/I{s/^/#_cmake_modify_IGNORE /g}' \
		-i {} + || die "${LINENO}: failed to disable hardcoded settings"
	local x
	for x in $(find "${CMAKE_USE_DIR}" -name CMakeLists.txt -exec grep -l "^#_cmake_modify_IGNORE" {} +;); do
		einfo "Hardcoded definition(s) removed in $(echo "${x}" | cut -c $((${#CMAKE_USE_DIR}+2))-):"
		einfo "$(grep -se '^#_cmake_modify_IGNORE' ${x} | cut -c 22-99)"
	done

	# NOTE Append some useful summary here
	cat >> "${CMAKE_USE_DIR}"/CMakeLists.txt <<- _EOF_ || die

		message(STATUS "<<< Gentoo configuration >>>
		Build type      \${CMAKE_BUILD_TYPE}
		Install path    \${CMAKE_INSTALL_PREFIX}
		Compiler flags:
		C               \${CMAKE_C_FLAGS}
		C++             \${CMAKE_CXX_FLAGS}
		Linker flags:
		Executable      \${CMAKE_EXE_LINKER_FLAGS}
		Module          \${CMAKE_MODULE_LINKER_FLAGS}
		Shared          \${CMAKE_SHARED_LINKER_FLAGS}\n")
	_EOF_
}

# @FUNCTION: cmake_src_prepare
# @DESCRIPTION:
# Apply ebuild and user patches. *MUST* be run or cmake_src_configure will fail.
cmake_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${EAPI} == 7 ]]; then
		pushd "${S}" > /dev/null || die # workaround from cmake-utils
		# in EAPI-8, we use current working directory instead, bug #704524
		# esp. test with 'special' pkgs like: app-arch/brotli, media-gfx/gmic, net-libs/quiche
	fi
	_cmake_check_build_dir

	default_src_prepare

	# check if CMakeLists.txt exists and if not then die
	if [[ ! -e ${CMAKE_USE_DIR}/CMakeLists.txt ]] ; then
		eerror "Unable to locate CMakeLists.txt under:"
		eerror "\"${CMAKE_USE_DIR}/CMakeLists.txt\""
		eerror "Consider not inheriting the cmake eclass."
		die "FATAL: Unable to find CMakeLists.txt"
	fi

	local modules_list
	if [[ ${EAPI} == 7 && $(declare -p CMAKE_REMOVE_MODULES_LIST) != "declare -a"* ]]; then
		modules_list=( ${CMAKE_REMOVE_MODULES_LIST} )
	else
		modules_list=( "${CMAKE_REMOVE_MODULES_LIST[@]}" )
	fi

	local name
	for name in "${modules_list[@]}" ; do
		if [[ ${EAPI} == 7 ]]; then
			find "${S}" -name ${name}.cmake -exec rm -v {} + || die
		else
			find -name "${name}.cmake" -exec rm -v {} + || die
		fi
	done

	# Remove dangerous things.
	_cmake_modify-cmakelists

	if [[ ${EAPI} == 7 ]]; then
		popd > /dev/null || die
	fi

	# Make ${CMAKE_USE_DIR} (in EAPI-7: ${S}) read-only in order to detect
	# broken build systems.
	if [[ ${CMAKE_QA_SRC_DIR_READONLY} && ! ${CMAKE_IN_SOURCE_BUILD} ]]; then
		if [[ ${EAPI} == 7 ]]; then
			chmod -R a-w "${S}"
		else
			chmod -R a-w "${CMAKE_USE_DIR}"
		fi
	fi

	_CMAKE_SRC_PREPARE_HAS_RUN=1
}

# @VARIABLE: MYCMAKEARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# User-controlled environment variable containing arguments to be passed to
# cmake in cmake_src_configure.

# @FUNCTION: cmake_src_configure
# @DESCRIPTION:
# General function for configuring with cmake. Default behaviour is to start an
# out-of-source build.
# Passes arguments to cmake by reading from an optionally pre-defined local
# mycmakeargs bash array.
# @CODE
# src_configure() {
# 	local mycmakeargs=(
# 		$(cmake_use_find_package foo LibFoo)
# 	)
# 	cmake_src_configure
# }
# @CODE
cmake_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${_CMAKE_SRC_PREPARE_HAS_RUN} ]] || \
		die "FATAL: cmake_src_prepare has not been run"

	_cmake_check_build_dir

	# Fix xdg collision with sandbox
	xdg_environment_reset

	# Prepare Gentoo override rules (set valid compiler, append CPPFLAGS etc.)
	local build_rules=${BUILD_DIR}/gentoo_rules.cmake

	cat > "${build_rules}" <<- _EOF_ || die
		set(CMAKE_ASM_COMPILE_OBJECT "<CMAKE_ASM_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "ASM compile command" FORCE)
		set(CMAKE_ASM-ATT_COMPILE_OBJECT "<CMAKE_ASM-ATT_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c -x assembler <SOURCE>" CACHE STRING "ASM-ATT compile command" FORCE)
		set(CMAKE_ASM-ATT_LINK_FLAGS "-nostdlib" CACHE STRING "ASM-ATT link flags" FORCE)
		set(CMAKE_C_COMPILE_OBJECT "<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "C compile command" FORCE)
		set(CMAKE_CXX_COMPILE_OBJECT "<CMAKE_CXX_COMPILER> <DEFINES> <INCLUDES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "C++ compile command" FORCE)
		set(CMAKE_Fortran_COMPILE_OBJECT "<CMAKE_Fortran_COMPILER> <DEFINES> <INCLUDES> ${FCFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "Fortran compile command" FORCE)
	_EOF_

	local myCC=$(tc-getCC) myCXX=$(tc-getCXX) myFC=$(tc-getFC)

	# !!! IMPORTANT NOTE !!!
	# Single slash below is intentional. CMake is weird and wants the
	# CMAKE_*_VARIABLES split into two elements: the first one with
	# compiler path, and the second one with all command-line options,
	# space separated.
	local toolchain_file=${BUILD_DIR}/gentoo_toolchain.cmake
	cat > ${toolchain_file} <<- _EOF_ || die
		set(CMAKE_ASM_COMPILER "${myCC/ /;}")
		set(CMAKE_ASM-ATT_COMPILER "${myCC/ /;}")
		set(CMAKE_C_COMPILER "${myCC/ /;}")
		set(CMAKE_CXX_COMPILER "${myCXX/ /;}")
		set(CMAKE_Fortran_COMPILER "${myFC/ /;}")
		set(CMAKE_AR $(type -P $(tc-getAR)) CACHE FILEPATH "Archive manager" FORCE)
		set(CMAKE_RANLIB $(type -P $(tc-getRANLIB)) CACHE FILEPATH "Archive index generator" FORCE)
		set(CMAKE_SYSTEM_PROCESSOR "${CHOST%%-*}")
	_EOF_

	# We are using the C compiler for assembly by default.
	local -x ASMFLAGS=${CFLAGS}
	local -x PKG_CONFIG=$(tc-getPKG_CONFIG)

	if tc-is-cross-compiler; then
		local sysname
		case "${KERNEL:-linux}" in
			Cygwin) sysname="CYGWIN_NT-5.1" ;;
			HPUX) sysname="HP-UX" ;;
			linux) sysname="Linux" ;;
			Winnt)
				sysname="Windows"
				cat >> "${toolchain_file}" <<- _EOF_ || die
					set(CMAKE_RC_COMPILER $(tc-getRC))
				_EOF_
				;;
			*) sysname="${KERNEL}" ;;
		esac

		cat >> "${toolchain_file}" <<- _EOF_ || die
			set(CMAKE_SYSTEM_NAME "${sysname}")
		_EOF_

		if [ "${SYSROOT:-/}" != "/" ] ; then
			# When cross-compiling with a sysroot (e.g. with crossdev's emerge wrappers)
			# we need to tell cmake to use libs/headers from the sysroot but programs from / only.
			cat >> "${toolchain_file}" <<- _EOF_ || die
				set(CMAKE_SYSROOT "${ESYSROOT}")
				set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
				set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
				set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
			_EOF_
		fi
	fi

	if use prefix-guest; then
		cat >> "${build_rules}" <<- _EOF_ || die
			# in Prefix we need rpath and must ensure cmake gets our default linker path
			# right ... except for Darwin hosts
			if(NOT APPLE)
				set(CMAKE_SKIP_RPATH OFF CACHE BOOL "" FORCE)
				set(CMAKE_PLATFORM_REQUIRED_RUNTIME_PATH "${EPREFIX}/usr/${CHOST}/lib/gcc;${EPREFIX}/usr/${CHOST}/lib;${EPREFIX}/usr/$(get_libdir);${EPREFIX}/$(get_libdir)" CACHE STRING "" FORCE)
			else()
				set(CMAKE_PREFIX_PATH "${EPREFIX}/usr" CACHE STRING "" FORCE)
				set(CMAKE_MACOSX_RPATH ON CACHE BOOL "" FORCE)
				set(CMAKE_SKIP_BUILD_RPATH OFF CACHE BOOL "" FORCE)
				set(CMAKE_SKIP_RPATH OFF CACHE BOOL "" FORCE)
				set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE CACHE BOOL "" FORCE)
			endif()
		_EOF_
	fi

	# Common configure parameters (invariants)
	local common_config=${BUILD_DIR}/gentoo_common_config.cmake
	local libdir=$(get_libdir)
	cat > "${common_config}" <<- _EOF_ || die
		set(CMAKE_GENTOO_BUILD ON CACHE BOOL "Indicate Gentoo package build")
		set(LIB_SUFFIX ${libdir/lib} CACHE STRING "library path suffix" FORCE)
		set(CMAKE_INSTALL_LIBDIR ${libdir} CACHE PATH "Output directory for libraries")
		set(CMAKE_INSTALL_INFODIR "${EPREFIX}/usr/share/info" CACHE PATH "")
		set(CMAKE_INSTALL_MANDIR "${EPREFIX}/usr/share/man" CACHE PATH "")
		set(CMAKE_USER_MAKE_RULES_OVERRIDE "${build_rules}" CACHE FILEPATH "Gentoo override rules")
		set(CMAKE_INSTALL_DOCDIR "${EPREFIX}/usr/share/doc/${PF}" CACHE PATH "")
		set(BUILD_SHARED_LIBS ON CACHE BOOL "")
	_EOF_

	if [[ -n ${_ECM_ECLASS} ]]; then
		echo 'set(ECM_DISABLE_QMLPLUGINDUMP ON CACHE BOOL "")' >> "${common_config}" || die
	fi

	# See bug 689410
	if [[ "${ARCH}" == riscv ]]; then
		echo 'set(CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX '"${libdir#lib}"' CACHE STRING "library search suffix" FORCE)' >> "${common_config}" || die
	fi

	if [[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]]; then
		echo 'set(CMAKE_COLOR_MAKEFILE OFF CACHE BOOL "pretty colors during make" FORCE)' >> "${common_config}" || die
	fi

	# See bug 735820
	if [[ ${EAPI} != 7 ]]; then
		echo 'set(CMAKE_INSTALL_ALWAYS 1)' >> "${common_config}" || die
	fi

	# Wipe the default optimization flags out of CMake
	if [[ ${CMAKE_BUILD_TYPE} != Gentoo ]]; then
		cat >> ${common_config} <<- _EOF_ || die
			set(CMAKE_ASM_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_ASM-ATT_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_EXE_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_MODULE_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_SHARED_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
			set(CMAKE_STATIC_LINKER_FLAGS_${CMAKE_BUILD_TYPE^^} "" CACHE STRING "")
		_EOF_
	fi

	# Make the array a local variable since <=portage-2.1.6.x does not support
	# global arrays (see bug #297255). But first make sure it is initialised.
	[[ -z ${mycmakeargs} ]] && declare -a mycmakeargs=()
	local mycmakeargstype=$(declare -p mycmakeargs 2>&-)
	if [[ "${mycmakeargstype}" != "declare -a mycmakeargs="* ]]; then
		die "mycmakeargs must be declared as array"
	fi

	local mycmakeargs_local=( "${mycmakeargs[@]}" )

	local warn_unused_cli=""
	if [[ ${CMAKE_WARN_UNUSED_CLI} == no ]] ; then
		warn_unused_cli="--no-warn-unused-cli"
	fi

	local generator_name
	case ${CMAKE_MAKEFILE_GENERATOR} in
		ninja) generator_name="Ninja" ;;
		emake) generator_name="Unix Makefiles" ;;
	esac

	# Common configure parameters (overridable)
	# NOTE CMAKE_BUILD_TYPE can be only overridden via CMAKE_BUILD_TYPE eclass variable
	# No -DCMAKE_BUILD_TYPE=xxx definitions will be in effect.
	local cmakeargs=(
		${warn_unused_cli}
		-C "${common_config}"
		-G "${generator_name}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		"${mycmakeargs_local[@]}"
		-DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}"
		-DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
	)

	# Handle quoted whitespace
	eval "local -a MYCMAKEARGS=( ${MYCMAKEARGS} )"
	cmakeargs+=( "${MYCMAKEARGS[@]}" )

	if [[ -n "${CMAKE_EXTRA_CACHE_FILE}" ]] ; then
		cmakeargs+=( -C "${CMAKE_EXTRA_CACHE_FILE}" )
	fi

	pushd "${BUILD_DIR}" > /dev/null || die
	debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: mycmakeargs is ${mycmakeargs_local[*]}"
	echo "${CMAKE_BINARY}" "${cmakeargs[@]}" "${CMAKE_USE_DIR}"
	"${CMAKE_BINARY}" "${cmakeargs[@]}" "${CMAKE_USE_DIR}" || die "cmake failed"
	popd > /dev/null || die
}

# @FUNCTION: cmake_src_compile
# @DESCRIPTION:
# General function for compiling with cmake. All arguments are passed
# to cmake_build.
cmake_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake_build "$@"
}

# @FUNCTION: cmake_build
# @DESCRIPTION:
# Function for building the package. Automatically detects the build type.
# All arguments are passed to eninja (default) or emake depending on the value
# of CMAKE_MAKEFILE_GENERATOR.
cmake_build() {
	debug-print-function ${FUNCNAME} "$@"

	_cmake_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die

	case ${CMAKE_MAKEFILE_GENERATOR} in
		emake)
			[[ -e Makefile ]] || die "Makefile not found. Error during configure stage."
			case ${CMAKE_VERBOSE} in
				OFF) emake "$@" ;;
				*) emake VERBOSE=1 "$@" ;;
			esac
			;;
		ninja)
			[[ -e build.ninja ]] || die "build.ninja not found. Error during configure stage."
			eninja "$@"
			;;
	esac

	popd > /dev/null || die
}

# @FUNCTION: cmake-utils_src_make
# @INTERNAL
# @DESCRIPTION:
# Banned. Use cmake_build instead.
cmake-utils_src_make() {
	die "cmake-utils_src_make is banned. Use cmake_build instead"
}

# @FUNCTION: cmake_src_test
# @DESCRIPTION:
# Function for testing the package. Automatically detects the build type.
cmake_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_cmake_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	[[ -e CTestTestfile.cmake ]] || { echo "No tests found. Skipping."; return 0 ; }

	[[ -n ${TEST_VERBOSE} ]] && myctestargs+=( --extra-verbose --output-on-failure )

	set -- ctest -j "$(makeopts_jobs "${MAKEOPTS}" 999)" \
		--test-load "$(makeopts_loadavg)" "${myctestargs[@]}" "$@"
	echo "$@" >&2
	if "$@" ; then
		einfo "Tests succeeded."
		popd > /dev/null || die
		return 0
	else
		if [[ -n "${CMAKE_YES_I_WANT_TO_SEE_THE_TEST_LOG}" ]] ; then
			# on request from Diego
			eerror "Tests failed. Test log ${BUILD_DIR}/Testing/Temporary/LastTest.log follows:"
			eerror "--START TEST LOG--------------------------------------------------------------"
			cat "${BUILD_DIR}/Testing/Temporary/LastTest.log"
			eerror "--END TEST LOG----------------------------------------------------------------"
			die "Tests failed."
		else
			die "Tests failed. When you file a bug, please attach the following file: \n\t${BUILD_DIR}/Testing/Temporary/LastTest.log"
		fi

		# die might not die due to nonfatal
		popd > /dev/null || die
		return 1
	fi
}

# @FUNCTION: cmake_src_install
# @DESCRIPTION:
# Function for installing the package. Automatically detects the build type.
cmake_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	DESTDIR="${D}" cmake_build install "$@"

	if [[ ${EAPI} == 7 ]]; then
		pushd "${S}" > /dev/null || die
		einstalldocs
		popd > /dev/null || die
	else
		pushd "${CMAKE_USE_DIR}" > /dev/null || die
		einstalldocs
		popd > /dev/null || die
	fi
}

fi

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
