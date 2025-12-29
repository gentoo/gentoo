# Copyright 1999-2026 Gentoo Authors
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
# @SUPPORTED_EAPIS: 8
# @PROVIDES: ninja-utils
# @BLURB: common ebuild functions for cmake-based packages
# @DESCRIPTION:
# The cmake eclass makes creating ebuilds for cmake-based packages much easier.
# It provides all inherited features (DOCS, HTML_DOCS, PATCHES) along with
# out-of-source builds (default) and in-source builds.

case ${EAPI} in
	8) ;;
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
# ${CMAKE_USE_DIR}_build (set inside _cmake_check_build_dir).

# @ECLASS_VARIABLE: CMAKE_BINARY
# @DESCRIPTION:
# Eclass can use different cmake binary than the one provided in by system.
: "${CMAKE_BINARY:=cmake}"

# @ECLASS_VARIABLE: CMAKE_BUILD_TYPE
# @DESCRIPTION:
# Set to override default CMAKE_BUILD_TYPE. Only useful for packages
# known to make use of "if (CMAKE_BUILD_TYPE MATCHES xxx)".
# If about to be set - needs to be set before invoking cmake_src_configure.
#
# The default is RelWithDebInfo as that is least likely to append undesirable
# flags. However, you may still need to sed CMake files or choose a different
# build type to achieve desirable results.
: "${CMAKE_BUILD_TYPE:=RelWithDebInfo}"

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
: "${CMAKE_MAKEFILE_GENERATOR:=ninja}"

# @ECLASS_VARIABLE: CMAKE_REMOVE_MODULES_LIST
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of .cmake modules to be removed in ${CMAKE_USE_DIR} during
# src_prepare, in order to force packages to use the system version.
# By default, contains "FindBLAS" and "FindLAPACK".
# Set to empty to disable removing modules entirely.
if [[ ${CMAKE_REMOVE_MODULES_LIST} ]]; then
	[[ ${CMAKE_REMOVE_MODULES_LIST@a} == *a* ]] ||
		die "CMAKE_REMOVE_MODULES_LIST must be an array"
else
	if ! [[ ${CMAKE_REMOVE_MODULES_LIST@a} == *a* && ${#CMAKE_REMOVE_MODULES_LIST[@]} -eq 0 ]]; then
		CMAKE_REMOVE_MODULES_LIST=( FindBLAS FindLAPACK )
	fi
fi

# @ECLASS_VARIABLE: CMAKE_USE_DIR
# @DESCRIPTION:
# Sets the directory where we are working with cmake, for example when
# application uses autotools and only one plugin needs to be done by cmake.
# By default it uses current working directory.

# @ECLASS_VARIABLE: CMAKE_VERBOSE
# @USER_VARIABLE
# @DESCRIPTION:
# Set to OFF to disable verbose messages during compilation
: "${CMAKE_VERBOSE:=ON}"

# @ECLASS_VARIABLE: CMAKE_WARN_UNUSED_CLI
# @DESCRIPTION:
# Warn about variables that are declared on the command line
# but not used. Might give false-positives.
# "no" to disable or anything else to enable.
# The default is set to "yes" (enabled).
: "${CMAKE_WARN_UNUSED_CLI:=yes}"

# @ECLASS_VARIABLE: CMAKE_ECM_MODE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Default value is "auto", which means _cmake_modify-cmakelists will make an
# effort to detect find_package(ECM) in CMakeLists.txt.  If set to true, make
# extra checks and add common config settings related to ECM (KDE Extra CMake
# Modules).  If set to false, do nothing.
: "${CMAKE_ECM_MODE:=auto}"

# @ECLASS_VARIABLE: CMAKE_EXTRA_CACHE_FILE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specifies an extra cache file to pass to cmake. This is the analog of EXTRA_ECONF
# for econf and is needed to pass TRY_RUN results when cross-compiling.
# Should be set by user in a per-package basis in /etc/portage/package.env.

# @ECLASS_VARIABLE: CMAKE_QA_COMPAT_SKIP
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set, skip detection of CMakeLists.txt unsupported in CMake 4 in case of
# false positives (e.g. unused outdated bundled libs).

# @ECLASS_VARIABLE: _CMAKE_MINREQVER_CMAKE305
# @DEFAULT_UNSET
# @DESCRIPTION:
# Internal array containing <file>:<version> tuples detected by
# _cmake_minreqver-get() for any CMake file with cmake_minimum_required
# version lower than 3.5.
_CMAKE_MINREQVER_CMAKE305=()

# @ECLASS_VARIABLE: _CMAKE_MINREQVER_CMAKE310
# @DEFAULT_UNSET
# @DESCRIPTION:
# Internal array containing <file>:<version> tuples detected by
# _cmake_minreqver-get() for any CMake file with cmake_minimum_required
# version lower than 3.10 (causes CMake warnings as of 4.0) on top of those
# already added to _CMAKE_MINREQVER_CMAKE305.
_CMAKE_MINREQVER_CMAKE310=()

# @ECLASS_VARIABLE: _CMAKE_MINREQVER_CMAKE316
# @DEFAULT_UNSET
# @DESCRIPTION:
# Internal array containing <file>:<version> tuples detected by
# _cmake_minreqver-get() for any CMake file with cmake_minimum_required
# version lower than 3.16 (causes ECM warnings since 5.100), on top of those
# already added to _CMAKE_MINREQVER_CMAKE305 and _CMAKE_MINREQVER_CMAKE310.
_CMAKE_MINREQVER_CMAKE316=()

# @ECLASS_VARIABLE: CMAKE_QA_SRC_DIR_READONLY
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# After running cmake_src_prepare, sets ${CMAKE_USE_DIR} to read-only.
# This is a user flag and should under _no circumstances_ be set in the
# ebuild. Helps in improving QA of build systems that write to source tree.

# @ECLASS_VARIABLE: CMAKE_SKIP_TESTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of tests that should be skipped when running CTest.

case ${CMAKE_BUILD_TYPE} in
	Gentoo)
		ewarn "\${CMAKE_BUILD_TYPE} \"Gentoo\" is a no-op. Default is RelWithDebInfo."
		;;
	*) ;;
esac

case ${CMAKE_ECM_MODE} in
	auto|true|false) ;;
	*)
		eerror "Unknown value for \${CMAKE_ECM_MODE}"
		die "Value ${CMAKE_ECM_MODE} is not supported"
		;;
esac

case ${CMAKE_MAKEFILE_GENERATOR} in
	emake)
		BDEPEND="dev-build/make"
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
	BDEPEND+=" >=dev-build/cmake-3.28.5"
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
# @USAGE: [-f <filename or directory>] <subdirectory> [<subdirectories>]
# @DESCRIPTION:
# Comment out one or more add_subdirectory calls with #DONOTBUILD in
# a) a given file path (error out on nonexisting path)
# b) a CMakeLists.txt file inside a given directory (ewarn if not found)
# c) CMakeLists.txt in current directory (do nothing if not found).
cmake_comment_add_subdirectory() {
	local d filename="CMakeLists.txt"
	if [[ $# -lt 1 ]]; then
		die "${FUNCNAME[0]} must be passed at least one subdirectory name to comment"
	fi
	case ${1} in
		-f)
			if [[ $# -ge 3 ]]; then
				filename="${2}"
				if [[ -d ${filename} ]]; then
					filename+="/CMakeLists.txt"
					if [[ ! -e ${filename} ]]; then
						ewarn "You've given me nothing to work with in ${filename}!"
						return
					fi
				elif [[ ! -e ${filename} ]]; then
					die "${FUNCNAME}: called on non-existing ${filename}"
				fi
			else
				die "${FUNCNAME[0]}: bad number of arguments: -f <filename or directory> <subdirectory> expected"
			fi
			shift 2
			;;
		*)
			[[ -e ${filename} ]] || return
			;;
	esac

	for d in "$@"; do
		d=${d//\//\\/}
		sed -e "/add_subdirectory[[:space:]]*([[:space:]]*${d}\([[:space:]][a-Z_ ]*\|[[:space:]]*\))/I s/^/#DONOTBUILD /" \
			-i ${filename} || die "failed to comment add_subdirectory(${d})"
	done
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

# @FUNCTION: _cmake_check_build_dir
# @INTERNAL
# @DESCRIPTION:
# Determine using IN or OUT source build
_cmake_check_build_dir() {
	# Since EAPI-8 we use current working directory, bug #704524
	: "${CMAKE_USE_DIR:=${PWD}}"
	if [[ -n ${CMAKE_IN_SOURCE_BUILD} ]]; then
		# we build in source dir
		BUILD_DIR="${CMAKE_USE_DIR}"
	else
		: "${BUILD_DIR:=${CMAKE_USE_DIR}_build}"

		# Avoid creating ${WORKDIR}_build (which is above WORKDIR).
		# TODO: For EAPI > 8, we should ban S=WORKDIR for CMake.
		# See bug #889420.
		if [[ ${S} == "${WORKDIR}" && ${BUILD_DIR} == "${WORKDIR}_build" ]] ; then
			eqawarn "QA Notice: S=WORKDIR is deprecated for cmake.eclass."
			eqawarn "Please relocate the sources in src_unpack."
			BUILD_DIR="${WORKDIR}"/${P}_build
		fi
	fi

	einfo "Source directory (CMAKE_USE_DIR): \"${CMAKE_USE_DIR}\""
	einfo "Build directory  (BUILD_DIR):     \"${BUILD_DIR}\""

	mkdir -p "${BUILD_DIR}" || die
}

# @FUNCTION: _cmake_minreqver-get
# @USAGE: <path>
# @INTERNAL
# @DESCRIPTION:
# Internal function for extracting cmake_minimum_required version from a
# given CMake file <path>.  Echos minimum version if found.
_cmake_minreqver-get() {
	if [[ $# -ne 1 ]]; then
		die "${FUNCNAME[0]} must be passed exactly one argument"
	fi
	local ver=$(sed -ne "/^\s*cmake_minimum_required/I{s/.*\(\.\.\.*\|\s\)\([0-9][0-9.]*\)\([)]\|\s\).*$/\2/p;q}" \
		"${1}" 2>/dev/null \
	)
	[[ -n ${ver} ]] && echo ${ver}
}

# @FUNCTION: _cmake_minreqver-info
# @INTERNAL
# @DESCRIPTION:
# QA Notice and file listings for any CMake file not meeting various minimum
# standards for cmake_minimum_required.  May be called from prepare or install
# phase, adjusts QA notice accordingly (build or installed files warning).
_cmake_minreqver-info() {
	local warnlvl
	[[ ${#_CMAKE_MINREQVER_CMAKE305[@]} != 0 ]] && warnlvl=305
	[[ ${#_CMAKE_MINREQVER_CMAKE310[@]} != 0 ]] || [[ -n ${warnlvl} ]] && warnlvl=310
	[[ ${CMAKE_ECM_MODE} == true ]] &&
		{ [[ ${#_CMAKE_MINREQVER_CMAKE316[@]} != 0 ]] || [[ -n ${warnlvl} ]]; } && warnlvl=316

	local weak_qaw="QA Notice: "
	minreqver_qanotice() {
		bug() {
			case ${1} in
				305) echo "951350" ;;
				310) echo "964405" ;;
				316) echo "964407" ;;
			esac
		}
		minreqver_qanotice_prepare() {
			case ${1} in
				305)
					eqawarn "${weak_qaw}Compatibility with CMake < 3.5 has been removed from CMake 4,"
					eqawarn "${CATEGORY}/${PN} will fail to build w/o a fix."
					;;
				310) eqawarn "${weak_qaw}Compatibility with CMake < 3.10 will be removed in a future release." ;;
				316) eqawarn "${weak_qaw}Compatibility w/ CMake < 3.16 will be removed in future ECM release." ;;
			esac
		}
		minreqver_qanotice_install() {
			case ${1} in
				305)
					eqawarn "${weak_qaw}Package installs CMake module(s) incompatible with CMake 4,"
					eqawarn "breaking any packages relying on it."
					;;
				31[06])
					eqawarn "${weak_qaw}Package installs CMake module(s) w/ <${1/3/3.} minimum version that will"
					eqawarn "be unsupported by future releases and is going to break any packages relying on it."
					;;
			esac
		}
		minreqver_qanotice_${EBUILD_PHASE} ${1}
		eqawarn "See also tracker bug #$(bug ${1}); check existing or file a new bug for this package."
		case ${1} in
			305)	eqawarn "Please also take it upstream." ;;
			31[06])	eqawarn "If not fixed in upstream's code repository, we should make sure they are aware." ;;
		esac
		eqawarn
		weak_qaw="" # weak notice: no "QA Notice" starting with second call
	}

	local info
	# <eqawarn msg> <_CMAKE_MINREQVER_* array>
	minreqver_listing() {
		[[ ${#@} -gt 1 ]] || return
		eqawarn "${1}"
		shift
		for info in "${@}"; do
			eqawarn "  ${info}";
		done
		eqawarn
	}

	# CMake 4-caused error is highest priority and must always be shown
	if [[ ${#_CMAKE_MINREQVER_CMAKE305[@]} != 0 ]]; then
		minreqver_qanotice 305
		minreqver_listing "The following files are causing errors:" ${_CMAKE_MINREQVER_CMAKE305[*]}
	fi
	# for warnings, we only want the latest relevant one, but list all flagged files
	if [[ ${warnlvl} -ge 310 ]]; then
		minreqver_qanotice ${warnlvl}
		minreqver_listing "The following files are causing warnings:" ${_CMAKE_MINREQVER_CMAKE310[*]}
		[[ ${warnlvl} == 316 ]] &&
			minreqver_listing "The following files are causing warnings:" ${_CMAKE_MINREQVER_CMAKE316[*]}
	fi
	if [[ ${warnlvl} ]]; then
		if [[ ${EBUILD_PHASE} == prepare && ${#_CMAKE_MINREQVER_CMAKE305[@]} != 0 ]] && has_version -b ">=dev-build/cmake-4"; then
			eqawarn "CMake 4 detected; building with -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
			eqawarn "This is merely a workaround to avoid CMake Error and *not* a permanent fix;"
			eqawarn "there may be new build or runtime bugs as a result."
			eqawarn
		fi
		eqawarn "An upstreamable patch should take any resulting CMake policy changes"
		eqawarn "into account. See also:"
		eqawarn "  https://cmake.org/cmake/help/latest/manual/cmake-policies.7.html"
	fi
}

# @FUNCTION: cmake_prepare-per-cmakelists
# @USAGE: <path-to-current-CMakeLists.txt>
# @DESCRIPTION:
# Override this to be provided with a hook into the cmake_src_prepare loop
# over all CMakeLists.txt below CMAKE_USE_DIR. Will be called from inside
# that loop with <path-to-current-CMakeLists.txt> as single argument.
# Used for recursive CMakeLists.txt detections and modifications.
cmake_prepare-per-cmakelists() {
	return
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

	local file ver
	while read -d '' -r file ; do
		# Comment out all set (<some_should_be_user_defined_variable> value)
		sed \
			-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_BUILD_TYPE\([[:space:]].*)\|)\)/I{s/^/#_cmake_modify_IGNORE /g}' \
			-e '/^[[:space:]]*set[[:space:]]*([[:space:]]*CMAKE_\(COLOR_MAKEFILE\|INSTALL_PREFIX\|VERBOSE_MAKEFILE\)[[:space:]].*)/I{s/^/#_cmake_modify_IGNORE /g}' \
			-i "${file}" || die "failed to disable hardcoded settings"
		readarray -t mod_lines < <(grep -se "^#_cmake_modify_IGNORE" "${file}")
		if [[ ${#mod_lines[*]} -gt 0 ]]; then
			einfo "Hardcoded definition(s) removed in ${file/${CMAKE_USE_DIR%\/}\//}:"
			local mod_line
			for mod_line in "${mod_lines[@]}"; do
				einfo "${mod_line:22:99}"
			done
		fi
		if [[ ${CMAKE_ECM_MODE} == auto ]] && grep -Eq "\s*find_package\s*\(\s*ECM " "${file}"; then
			CMAKE_ECM_MODE=true
		fi
		ver=$(_cmake_minreqver-get "${file}")
		# Flag unsupported minimum CMake versions unless CMAKE_QA_COMPAT_SKIP is set
		if [[ -n "${ver}" && ! ${CMAKE_QA_COMPAT_SKIP} ]]; then
			# we don't want duplicates that were already flagged
			if ver_test "${ver}" -lt "3.5"; then
				_CMAKE_MINREQVER_CMAKE305+=( "${file#"${CMAKE_USE_DIR}/"}":"${ver}" )
			elif ver_test "${ver}" -lt "3.10"; then
				_CMAKE_MINREQVER_CMAKE310+=( "${file#"${CMAKE_USE_DIR}/"}":"${ver}" )
			elif ver_test "${ver}" -lt "3.16"; then
				_CMAKE_MINREQVER_CMAKE316+=( "${file#"${CMAKE_USE_DIR}/"}":"${ver}" )
			fi
		fi
		cmake_prepare-per-cmakelists ${file}
	done < <(find "${CMAKE_USE_DIR}" -type f -iname "CMakeLists.txt" -print0 || die)

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

# @FUNCTION: cmake_prepare
# @DESCRIPTION:
# Check existence of and sanitise CMake files, then make ${CMAKE_USE_DIR}
# read-only.  *MUST* be run or cmake_src_configure will fail.
cmake_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	_cmake_check_build_dir

	# Check if CMakeLists.txt exists and if not then die
	if [[ ! -e ${CMAKE_USE_DIR}/CMakeLists.txt ]] ; then
		eerror "Unable to locate CMakeLists.txt under:"
		eerror "\"${CMAKE_USE_DIR}/CMakeLists.txt\""
		eerror "Consider not inheriting the cmake eclass."
		die "FATAL: Unable to find CMakeLists.txt"
	fi

	local modules_list=( "${CMAKE_REMOVE_MODULES_LIST[@]}" )

	local name
	for name in "${modules_list[@]}" ; do
		find -name "${name}.cmake" -exec rm -v {} + || die
	done

	# Remove dangerous things.
	_cmake_modify-cmakelists
	_cmake_minreqver-info

	# Make ${CMAKE_USE_DIR} read-only in order to detect broken build systems
	if [[ ${CMAKE_QA_SRC_DIR_READONLY} && ! ${CMAKE_IN_SOURCE_BUILD} ]]; then
		chmod -R a-w "${CMAKE_USE_DIR}"
	fi

	_CMAKE_PREPARE_HAS_RUN=1
}

# @FUNCTION: cmake_src_prepare
# @DESCRIPTION:
# Apply ebuild and user patches via default_src_prepare.  In case of
# conflict with another eclass' src_prepare phase, use cmake_prepare
# instead.
cmake_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	default_src_prepare
	cmake_prepare
}

# @ECLASS_VARIABLE: MYCMAKEARGS
# @USER_VARIABLE
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

	if [[ -z ${_CMAKE_PREPARE_HAS_RUN} ]]; then
		die "FATAL: cmake_src_prepare (or cmake_prepare) has not been run"
	fi

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
	fi

	if [[ ${SYSROOT:-/} != / ]] ; then
		# When building with a sysroot (e.g. with crossdev's emerge wrappers)
		# we need to tell cmake to use libs/headers from the sysroot but programs from / only.
		cat >> "${toolchain_file}" <<- _EOF_ || die
			set(CMAKE_SYSROOT "${ESYSROOT}")
			set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
			set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
			set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
		_EOF_
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
		set(Python3_FIND_UNVERSIONED_NAMES FIRST CACHE STRING "") # FindPythonInterp, Gentoo-bug #835799
		set(CMAKE_POLICY_DEFAULT_CMP0094 NEW CACHE STRING "" ) # FindPython, Gentoo-bug #959154
		set(CMAKE_DISABLE_PRECOMPILE_HEADERS ON CACHE BOOL "")
		set(CMAKE_INTERPROCEDURAL_OPTIMIZATION OFF CACHE BOOL "")
		set(CMAKE_TLS_VERIFY ON CACHE BOOL "")
		set(CMAKE_COMPILE_WARNING_AS_ERROR OFF CACHE BOOL "")
		set(CMAKE_LINK_WARNING_AS_ERROR OFF CACHE BOOL "")
	_EOF_

	# See bug 689410
	if [[ "${ARCH}" == riscv ]]; then
		echo 'set(CMAKE_FIND_LIBRARY_CUSTOM_LIB_SUFFIX '"${libdir#lib}"' CACHE STRING "library search suffix" FORCE)' >> "${common_config}" || die
	fi

	if [[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]]; then
		echo 'set(CMAKE_COLOR_MAKEFILE OFF CACHE BOOL "pretty colors during make" FORCE)' >> "${common_config}" || die
	fi

	# Wipe the default optimization flags out of CMake
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
		set(CMAKE_INSTALL_ALWAYS 1) # see Gentoo-bug 735820
	_EOF_

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

	if ! [[ ${CMAKE_QA_COMPAT_SKIP} ]] &&
		[[ -n ${_CMAKE_MINREQVER_CMAKE305[@]} ]] &&
		has_version -b ">=dev-build/cmake-4"; then
		cmakeargs+=( -DCMAKE_POLICY_VERSION_MINIMUM=3.5 )
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
			case ${CMAKE_VERBOSE} in
				OFF) NINJA_VERBOSE=OFF eninja "$@" ;;
				*) eninja "$@" ;;
			esac
			;;
	esac

	popd > /dev/null || die
}

# @ECLASS_VARIABLE: CTEST_JOBS
# @USER_VARIABLE
# @DESCRIPTION:
# Maximum number of CTest jobs to run in parallel.  If unset, the value
# will be determined from make options.

# @ECLASS_VARIABLE: CTEST_LOADAVG
# @USER_VARIABLE
# @DESCRIPTION:
# Maximum load, over which no new jobs will be started by CTest.  Note
# that unlike make, CTest will not start *any* jobs if the load
# is exceeded.  If unset, the value will be determined from make options.

# @FUNCTION: cmake_src_test
# @DESCRIPTION:
# Function for testing the package. Automatically detects the build type.
cmake_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_cmake_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die
	[[ -e CTestTestfile.cmake ]] || { echo "No tests found. Skipping."; return 0 ; }

	[[ -n ${TEST_VERBOSE} ]] && myctestargs+=( --extra-verbose --output-on-failure )
	[[ -n ${CMAKE_SKIP_TESTS} ]] && myctestargs+=( -E '('$( IFS='|'; echo "${CMAKE_SKIP_TESTS[*]}")')'  )

	set -- ctest -j "${CTEST_JOBS:-$(get_makeopts_jobs 999)}" \
		--test-load "${CTEST_LOADAVG:-$(get_makeopts_loadavg)}" \
		"${myctestargs[@]}" "$@"
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
			die -n "Tests failed."
		else
			eerror "Tests failed. When you file a bug, please attach the following file:"
			eerror "\t${BUILD_DIR}/Testing/Temporary/LastTest.log"
			die -n "Tests failed."
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

	DESTDIR="${D}" cmake_build "$@" install

	pushd "${CMAKE_USE_DIR}" > /dev/null || die
		einstalldocs
	popd > /dev/null || die

	# reset these for install phase run
	_CMAKE_MINREQVER_CMAKE305=()
	_CMAKE_MINREQVER_CMAKE310=()
	_CMAKE_MINREQVER_CMAKE316=()
	local file ver
	while read -d '' -r file ; do
		# Flag unsupported minimum CMake versions unless CMAKE_QA_COMPAT_SKIP is set
		ver=$(_cmake_minreqver-get "${file}")
		if [[ -n "${ver}" && ! ${CMAKE_QA_COMPAT_SKIP} ]]; then
			if ver_test "${ver}" -lt "3.5"; then
				_CMAKE_MINREQVER_CMAKE305+=( "${file#"${D}"}":"${ver}" )
			elif ver_test "${ver}" -lt "3.10"; then
				_CMAKE_MINREQVER_CMAKE310+=( "${file#"${D}"}":"${ver}" )
			fi
		fi
	done < <(find "${D}" -type f -iname "*.cmake" -print0 || die)
	_cmake_minreqver-info
}

fi

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install
