# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: cmake-utils.eclass
# @MAINTAINER:
# kde@gentoo.org
# @AUTHOR:
# Tomáš Chvátal <scarabeus@gentoo.org>
# Maciej Mrozowski <reavertm@gentoo.org>
# (undisclosed contributors)
# Original author: Zephyrus (zephyrus@mirach.it)
# @BLURB: common ebuild functions for cmake-based packages
# @DESCRIPTION:
# The cmake-utils eclass makes creating ebuilds for cmake-based packages much easier.
# It provides all inherited features (DOCS, HTML_DOCS, PATCHES) along with out-of-source
# builds (default), in-source builds and an implementation of the well-known use_enable
# and use_with functions for CMake.

if [[ -z ${_CMAKE_UTILS_ECLASS} ]]; then
_CMAKE_UTILS_ECLASS=1


# @ECLASS-VARIABLE: BUILD_DIR
# @DESCRIPTION:
# Build directory where all cmake processed files should be generated.
# For in-source build it's fixed to ${CMAKE_USE_DIR}.
# For out-of-source build it can be overridden, by default it uses
# ${WORKDIR}/${P}_build.
#
# This variable has been called CMAKE_BUILD_DIR formerly.
# It is set under that name for compatibility.

# @ECLASS-VARIABLE: CMAKE_BINARY
# @DESCRIPTION:
# Eclass can use different cmake binary than the one provided in by system.
: ${CMAKE_BINARY:=cmake}

# @ECLASS-VARIABLE: CMAKE_BUILD_TYPE
# @DESCRIPTION:
# Set to override default CMAKE_BUILD_TYPE. Only useful for packages
# known to make use of "if (CMAKE_BUILD_TYPE MATCHES xxx)".
# If about to be set - needs to be set before invoking cmake-utils_src_configure.
# You usualy do *NOT* want nor need to set it as it pulls CMake default build-type
# specific compiler flags overriding make.conf.
: ${CMAKE_BUILD_TYPE:=Gentoo}

# @ECLASS-VARIABLE: CMAKE_IN_SOURCE_BUILD
# @DESCRIPTION:
# Set to enable in-source build.

# @ECLASS-VARIABLE: CMAKE_MAKEFILE_GENERATOR
# @DESCRIPTION:
# Specify a makefile generator to be used by cmake.
# At this point only "emake" and "ninja" are supported.
: ${CMAKE_MAKEFILE_GENERATOR:=emake}

# @ECLASS-VARIABLE: CMAKE_MIN_VERSION
# @DESCRIPTION:
# Specify the minimum required CMake version.
: ${CMAKE_MIN_VERSION:=2.8.12}

# @ECLASS-VARIABLE: CMAKE_REMOVE_MODULES
# @DESCRIPTION:
# Do we want to remove anything? yes or whatever else for no
: ${CMAKE_REMOVE_MODULES:=yes}
CMAKE_REMOVE_MODULES="${CMAKE_REMOVE_MODULES:-yes}"

# @ECLASS-VARIABLE: CMAKE_REMOVE_MODULES_LIST
# @DESCRIPTION:
# Space-separated list of CMake modules that will be removed in $S during src_prepare,
# in order to force packages to use the system version.
: ${CMAKE_REMOVE_MODULES_LIST:=FindBLAS FindLAPACK}

# @ECLASS-VARIABLE: CMAKE_USE_DIR
# @DESCRIPTION:
# Sets the directory where we are working with cmake.
# For example when application uses autotools and only one
# plugin needs to be done by cmake.
# By default it uses ${S}.

# @ECLASS-VARIABLE: CMAKE_VERBOSE
# @DESCRIPTION:
# Set to OFF to disable verbose messages during compilation
: ${CMAKE_VERBOSE:=ON}

# @ECLASS-VARIABLE: CMAKE_WARN_UNUSED_CLI
# @DESCRIPTION:
# Warn about variables that are declared on the command line
# but not used. Might give false-positives.
# "no" to disable (default) or anything else to enable.
: ${CMAKE_WARN_UNUSED_CLI:=no}

# @ECLASS-VARIABLE: PREFIX
# @DESCRIPTION:
# Eclass respects PREFIX variable, though it's not recommended way to set
# install/lib/bin prefixes.
# Use -DCMAKE_INSTALL_PREFIX=... CMake variable instead.
: ${PREFIX:=/usr}

# @ECLASS-VARIABLE: WANT_CMAKE
# @DESCRIPTION:
# Specify if cmake-utils eclass should depend on cmake optionally or not.
# This is useful when only part of application is using cmake build system.
# Valid values are: always [default], optional (where the value is the useflag
# used for optionality)
: ${WANT_CMAKE:=always}

# @ECLASS-VARIABLE: CMAKE_EXTRA_CACHE_FILE
# @DESCRIPTION:
# Specifies an extra cache file to pass to cmake. This is the analog of EXTRA_ECONF
# for econf and is needed to pass TRY_RUN results when cross-compiling.
# Should be set by user in a per-package basis in /etc/portage/package.env.

CMAKEDEPEND=""
case ${WANT_CMAKE} in
	always)
		;;
	*)
		IUSE+=" ${WANT_CMAKE}"
		CMAKEDEPEND+="${WANT_CMAKE}? ( "
		;;
esac
inherit toolchain-funcs multilib flag-o-matic eutils

case ${EAPI} in
	2|3|4|5) : ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install

case ${CMAKE_MAKEFILE_GENERATOR} in
	emake)
		CMAKEDEPEND+=" sys-devel/make"
		;;
	ninja)
		CMAKEDEPEND+=" dev-util/ninja"
		;;
	*)
		eerror "Unknown value for \${CMAKE_MAKEFILE_GENERATOR}"
		die "Value ${CMAKE_MAKEFILE_GENERATOR} is not supported"
		;;
esac

if [[ ${PN} != cmake ]]; then
	CMAKEDEPEND+=" >=dev-util/cmake-${CMAKE_MIN_VERSION}"
fi

CMAKEDEPEND+=" userland_GNU? ( >=sys-apps/findutils-4.4.0 )"

[[ ${WANT_CMAKE} = always ]] || CMAKEDEPEND+=" )"

DEPEND="${CMAKEDEPEND}"
unset CMAKEDEPEND

# Internal functions used by cmake-utils_use_*
_use_me_now() {
	debug-print-function ${FUNCNAME} "$@"

	local uper capitalised x
	[[ -z $2 ]] && die "cmake-utils_use-$1 <USE flag> [<flag name>]"
	if [[ ! -z $3 ]]; then
		# user specified the use name so use it
		echo "-D$1$3=$(use $2 && echo ON || echo OFF)"
	else
		# use all various most used combinations
		uper=$(echo ${2} | tr '[:lower:]' '[:upper:]')
		capitalised=$(echo ${2} | sed 's/\<\(.\)\([^ ]*\)/\u\1\L\2/g')
		for x in $2 $uper $capitalised; do
			echo "-D$1$x=$(use $2 && echo ON || echo OFF) "
		done
	fi
}
_use_me_now_inverted() {
	debug-print-function ${FUNCNAME} "$@"

	local uper capitalised x
	[[ -z $2 ]] && die "cmake-utils_use-$1 <USE flag> [<flag name>]"
	if [[ ! -z $3 ]]; then
		# user specified the use name so use it
		echo "-D$1$3=$(use $2 && echo OFF || echo ON)"
	else
		# use all various most used combinations
		uper=$(echo ${2} | tr '[:lower:]' '[:upper:]')
		capitalised=$(echo ${2} | sed 's/\<\(.\)\([^ ]*\)/\u\1\L\2/g')
		for x in $2 $uper $capitalised; do
			echo "-D$1$x=$(use $2 && echo OFF || echo ON) "
		done
	fi
}

# Determine using IN or OUT source build
_check_build_dir() {
	: ${CMAKE_USE_DIR:=${S}}
	if [[ -n ${CMAKE_IN_SOURCE_BUILD} ]]; then
		# we build in source dir
		BUILD_DIR="${CMAKE_USE_DIR}"
	else
		# Respect both the old variable and the new one, depending
		# on which one was set by the ebuild.
		if [[ ! ${BUILD_DIR} && ${CMAKE_BUILD_DIR} ]]; then
			eqawarn "The CMAKE_BUILD_DIR variable has been renamed to BUILD_DIR."
			eqawarn "Please migrate the ebuild to use the new one."

			# In the next call, both variables will be set already
			# and we'd have to know which one takes precedence.
			_RESPECT_CMAKE_BUILD_DIR=1
		fi

		if [[ ${_RESPECT_CMAKE_BUILD_DIR} ]]; then
			BUILD_DIR=${CMAKE_BUILD_DIR:-${WORKDIR}/${P}_build}
		else
			: ${BUILD_DIR:=${WORKDIR}/${P}_build}
		fi
	fi

	# Backwards compatibility for getting the value.
	CMAKE_BUILD_DIR=${BUILD_DIR}

	mkdir -p "${BUILD_DIR}"
	echo ">>> Working in BUILD_DIR: \"$BUILD_DIR\""
}

# Determine which generator to use
_generator_to_use() {
	local generator_name

	case ${CMAKE_MAKEFILE_GENERATOR} in
		ninja)
			generator_name="Ninja"
			;;
		emake)
			generator_name="Unix Makefiles"
			;;
		*)
			eerror "Unknown value for \${CMAKE_MAKEFILE_GENERATOR}"
			die "Value ${CMAKE_MAKEFILE_GENERATOR} is not supported"
			;;
	esac

	echo ${generator_name}
}

# @FUNCTION: comment_add_subdirectory
# @USAGE: <subdirectory>
# @DESCRIPTION:
# Comment out an add_subdirectory call in CMakeLists.txt in the current directory
comment_add_subdirectory() {
        if [[ -z ${1} ]]; then
                die "comment_add_subdirectory must be passed the directory name to comment"
        fi

        if [[ -e "CMakeLists.txt" ]]; then
                sed -e "/add_subdirectory[[:space:]]*([[:space:]]*${1//\//\\/}[[:space:]]*)/s/^/#DONOTCOMPILE /" \
                        -i CMakeLists.txt || die "failed to comment add_subdirectory(${1})"
        fi
}

# @FUNCTION: cmake-utils_use_with
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_with. See ebuild(5).
#
# `cmake-utils_use_with foo FOO` echoes -DWITH_FOO=ON if foo is enabled
# and -DWITH_FOO=OFF if it is disabled.
cmake-utils_use_with() { _use_me_now WITH_ "$@" ; }

# @FUNCTION: cmake-utils_use_enable
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_use_enable foo FOO` echoes -DENABLE_FOO=ON if foo is enabled
# and -DENABLE_FOO=OFF if it is disabled.
cmake-utils_use_enable() { _use_me_now ENABLE_ "$@" ; }

# @FUNCTION: cmake-utils_use_find_package
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_use_find_package foo LibFoo` echoes -DCMAKE_DISABLE_FIND_PACKAGE_LibFoo=OFF
# if foo is enabled and -DCMAKE_DISABLE_FIND_PACKAGE_LibFoo=ON if it is disabled.
# This can be used to make find_package optional.
cmake-utils_use_find_package() { _use_me_now_inverted CMAKE_DISABLE_FIND_PACKAGE_ "$@" ; }

# @FUNCTION: cmake-utils_use_disable
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on inversion of use_enable. See ebuild(5).
#
# `cmake-utils_use_enable foo FOO` echoes -DDISABLE_FOO=OFF if foo is enabled
# and -DDISABLE_FOO=ON if it is disabled.
cmake-utils_use_disable() { _use_me_now_inverted DISABLE_ "$@" ; }

# @FUNCTION: cmake-utils_use_no
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_disable. See ebuild(5).
#
# `cmake-utils_use_no foo FOO` echoes -DNO_FOO=OFF if foo is enabled
# and -DNO_FOO=ON if it is disabled.
cmake-utils_use_no() { _use_me_now_inverted NO_ "$@" ; }

# @FUNCTION: cmake-utils_use_want
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_use_want foo FOO` echoes -DWANT_FOO=ON if foo is enabled
# and -DWANT_FOO=OFF if it is disabled.
cmake-utils_use_want() { _use_me_now WANT_ "$@" ; }

# @FUNCTION: cmake-utils_use_build
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_use_build foo FOO` echoes -DBUILD_FOO=ON if foo is enabled
# and -DBUILD_FOO=OFF if it is disabled.
cmake-utils_use_build() { _use_me_now BUILD_ "$@" ; }

# @FUNCTION: cmake-utils_use_has
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_use_has foo FOO` echoes -DHAVE_FOO=ON if foo is enabled
# and -DHAVE_FOO=OFF if it is disabled.
cmake-utils_use_has() { _use_me_now HAVE_ "$@" ; }

# @FUNCTION: cmake-utils_use_use
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_use_use foo FOO` echoes -DUSE_FOO=ON if foo is enabled
# and -DUSE_FOO=OFF if it is disabled.
cmake-utils_use_use() { _use_me_now USE_ "$@" ; }

# @FUNCTION: cmake-utils_use
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_use foo FOO` echoes -DFOO=ON if foo is enabled
# and -DFOO=OFF if it is disabled.
cmake-utils_use() { _use_me_now "" "$@" ; }

# @FUNCTION: cmake-utils_useno
# @USAGE: <USE flag> [flag name]
# @DESCRIPTION:
# Based on use_enable. See ebuild(5).
#
# `cmake-utils_useno foo NOFOO` echoes -DNOFOO=OFF if foo is enabled
# and -DNOFOO=ON if it is disabled.
cmake-utils_useno() { _use_me_now_inverted "" "$@" ; }

# Internal function for modifying hardcoded definitions.
# Removes dangerous definitions that override Gentoo settings.
_modify-cmakelists() {
	debug-print-function ${FUNCNAME} "$@"

	# Only edit the files once
	grep -qs "<<< Gentoo configuration >>>" "${CMAKE_USE_DIR}"/CMakeLists.txt && return 0

	# Comment out all set (<some_should_be_user_defined_variable> value)
	# TODO Add QA checker - inform when variable being checked for below is set in CMakeLists.txt
	find "${CMAKE_USE_DIR}" -name CMakeLists.txt \
		-exec sed -i -e '/^[[:space:]]*[sS][eE][tT][[:space:]]*([[:space:]]*CMAKE_BUILD_TYPE.*)/{s/^/#IGNORE /g}' {} + \
		-exec sed -i -e '/^[[:space:]]*[sS][eE][tT][[:space:]]*([[:space:]]*CMAKE_COLOR_MAKEFILE.*)/{s/^/#IGNORE /g}' {} + \
		-exec sed -i -e '/^[[:space:]]*[sS][eE][tT][[:space:]]*([[:space:]]*CMAKE_INSTALL_PREFIX.*)/{s/^/#IGNORE /g}' {} + \
		-exec sed -i -e '/^[[:space:]]*[sS][eE][tT][[:space:]]*([[:space:]]*CMAKE_VERBOSE_MAKEFILE.*)/{s/^/#IGNORE /g}' {} + \
		|| die "${LINENO}: failed to disable hardcoded settings"

	# NOTE Append some useful summary here
	cat >> "${CMAKE_USE_DIR}"/CMakeLists.txt <<- _EOF_ || die

		MESSAGE(STATUS "<<< Gentoo configuration >>>
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

enable_cmake-utils_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	pushd "${S}" > /dev/null

	debug-print "$FUNCNAME: PATCHES=$PATCHES"
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"
		
	debug-print "$FUNCNAME: applying user patches"
	epatch_user

	popd > /dev/null
}

# @VARIABLE: mycmakeargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional cmake defines as a bash array. Should be defined before calling
# src_configure.
# @CODE
# src_configure() {
# 	local mycmakeargs=(
# 		$(cmake-utils_use_with openconnect)
# 	)
#
# 	cmake-utils_src_configure
# }
# @CODE

enable_cmake-utils_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	[[ "${CMAKE_REMOVE_MODULES}" == "yes" ]] && {
		local name
		for name in ${CMAKE_REMOVE_MODULES_LIST} ; do
			find "${S}" -name ${name}.cmake -exec rm -v {} +
		done
	}

	_check_build_dir

	# check if CMakeLists.txt exist and if no then die
	if [[ ! -e ${CMAKE_USE_DIR}/CMakeLists.txt ]] ; then
		eerror "Unable to locate CMakeLists.txt under:"
		eerror "\"${CMAKE_USE_DIR}/CMakeLists.txt\""
		eerror "Consider not inheriting the cmake eclass."
		die "FATAL: Unable to find CMakeLists.txt"
	fi

	# Remove dangerous things.
	_modify-cmakelists

	# Fix xdg collision with sandbox
	export XDG_CONFIG_HOME="${T}"

	# @SEE CMAKE_BUILD_TYPE
	if [[ ${CMAKE_BUILD_TYPE} = Gentoo ]]; then
		# Handle release builds
		if ! has debug ${IUSE//+} || ! use debug; then
			local CPPFLAGS=${CPPFLAGS}
			append-cppflags -DNDEBUG
		fi
	fi

	# Prepare Gentoo override rules (set valid compiler, append CPPFLAGS etc.)
	local build_rules=${BUILD_DIR}/gentoo_rules.cmake
	cat > "${build_rules}" <<- _EOF_ || die
		SET (CMAKE_AR $(type -P $(tc-getAR)) CACHE FILEPATH "Archive manager" FORCE)
		SET (CMAKE_ASM_COMPILE_OBJECT "<CMAKE_C_COMPILER> <DEFINES> ${CFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "ASM compile command" FORCE)
		SET (CMAKE_C_COMPILE_OBJECT "<CMAKE_C_COMPILER> <DEFINES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "C compile command" FORCE)
		SET (CMAKE_CXX_COMPILE_OBJECT "<CMAKE_CXX_COMPILER> <DEFINES> ${CPPFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "C++ compile command" FORCE)
		SET (CMAKE_Fortran_COMPILE_OBJECT "<CMAKE_Fortran_COMPILER> <DEFINES> ${FCFLAGS} <FLAGS> -o <OBJECT> -c <SOURCE>" CACHE STRING "Fortran compile command" FORCE)
		SET (CMAKE_RANLIB $(type -P $(tc-getRANLIB)) CACHE FILEPATH "Archive index generator" FORCE)
		SET (PKG_CONFIG_EXECUTABLE $(type -P $(tc-getPKG_CONFIG)) CACHE FILEPATH "pkg-config executable" FORCE)
	_EOF_

	local toolchain_file=${BUILD_DIR}/gentoo_toolchain.cmake
	cat > ${toolchain_file} <<- _EOF_ || die
		SET (CMAKE_C_COMPILER $(tc-getCC))
		SET (CMAKE_CXX_COMPILER $(tc-getCXX))
		SET (CMAKE_Fortran_COMPILER $(tc-getFC))
	_EOF_

	if tc-is-cross-compiler; then
		local sysname
		case "${KERNEL:-linux}" in
			Cygwin) sysname="CYGWIN_NT-5.1" ;;
			HPUX) sysname="HP-UX" ;;
			linux) sysname="Linux" ;;
			Winnt)
				sysname="Windows"
				cat >> "${toolchain_file}" <<- _EOF_ || die
					SET (CMAKE_RC_COMPILER $(tc-getRC))
				_EOF_
				;;
			*) sysname="${KERNEL}" ;;
		esac

		cat >> "${toolchain_file}" <<- _EOF_ || die
			SET (CMAKE_SYSTEM_NAME "${sysname}")
		_EOF_

		if [ "${SYSROOT:-/}" != "/" ] ; then
			# When cross-compiling with a sysroot (e.g. with crossdev's emerge wrappers)
			# we need to tell cmake to use libs/headers from the sysroot but programs from / only.
			cat >> "${toolchain_file}" <<- _EOF_ || die
				set(CMAKE_FIND_ROOT_PATH "${SYSROOT}")
				set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
				set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
				set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
			_EOF_
		fi
	fi

	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

	if [[ ${EPREFIX} ]]; then
		cat >> "${build_rules}" <<- _EOF_ || die
			# in Prefix we need rpath and must ensure cmake gets our default linker path
			# right ... except for Darwin hosts
			IF (NOT APPLE)
			SET (CMAKE_SKIP_RPATH OFF CACHE BOOL "" FORCE)
			SET (CMAKE_PLATFORM_REQUIRED_RUNTIME_PATH "${EPREFIX}/usr/${CHOST}/lib/gcc;${EPREFIX}/usr/${CHOST}/lib;${EPREFIX}/usr/$(get_libdir);${EPREFIX}/$(get_libdir)"
			CACHE STRING "" FORCE)

			ELSE ()

			SET(CMAKE_PREFIX_PATH "${EPREFIX}${PREFIX}" CACHE STRING "" FORCE)
			SET(CMAKE_SKIP_BUILD_RPATH OFF CACHE BOOL "" FORCE)
			SET(CMAKE_SKIP_RPATH OFF CACHE BOOL "" FORCE)
			SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE CACHE BOOL "")
			SET(CMAKE_INSTALL_RPATH "${EPREFIX}${PREFIX}/lib;${EPREFIX}/usr/${CHOST}/lib/gcc;${EPREFIX}/usr/${CHOST}/lib;${EPREFIX}/usr/$(get_libdir);${EPREFIX}/$(get_libdir)" CACHE STRING "" FORCE)
			SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE CACHE BOOL "" FORCE)
			SET(CMAKE_INSTALL_NAME_DIR "${EPREFIX}${PREFIX}/lib" CACHE STRING "" FORCE)

			ENDIF (NOT APPLE)
		_EOF_
	fi

	# Common configure parameters (invariants)
	local common_config=${BUILD_DIR}/gentoo_common_config.cmake
	local libdir=$(get_libdir)
	cat > "${common_config}" <<- _EOF_ || die
		SET (LIB_SUFFIX ${libdir/lib} CACHE STRING "library path suffix" FORCE)
		SET (CMAKE_INSTALL_LIBDIR ${libdir} CACHE PATH "Output directory for libraries")
	_EOF_
	[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && echo 'SET (CMAKE_COLOR_MAKEFILE OFF CACHE BOOL "pretty colors during make" FORCE)' >> "${common_config}"

	# Convert mycmakeargs to an array, for backwards compatibility
	# Make the array a local variable since <=portage-2.1.6.x does not
	# support global arrays (see bug #297255).
	if [[ $(declare -p mycmakeargs 2>&-) != "declare -a mycmakeargs="* ]]; then
		local mycmakeargs_local=(${mycmakeargs})
	else
		local mycmakeargs_local=("${mycmakeargs[@]}")
	fi

	if [[ ${CMAKE_WARN_UNUSED_CLI} == no ]] ; then
		local warn_unused_cli="--no-warn-unused-cli"
	else
		local warn_unused_cli=""
	fi

	# Common configure parameters (overridable)
	# NOTE CMAKE_BUILD_TYPE can be only overriden via CMAKE_BUILD_TYPE eclass variable
	# No -DCMAKE_BUILD_TYPE=xxx definitions will be in effect.
	local cmakeargs=(
		${warn_unused_cli}
		-C "${common_config}"
		-G "$(_generator_to_use)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${PREFIX}"
		"${mycmakeargs_local[@]}"
		-DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}"
		-DCMAKE_INSTALL_DO_STRIP=OFF
		-DCMAKE_USER_MAKE_RULES_OVERRIDE="${build_rules}"
		-DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
		"${MYCMAKEARGS}"
	)

	if [[ -n "${CMAKE_EXTRA_CACHE_FILE}" ]] ; then
		cmakeargs+=( -C "${CMAKE_EXTRA_CACHE_FILE}" )
	fi

	pushd "${BUILD_DIR}" > /dev/null
	debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: mycmakeargs is ${mycmakeargs_local[*]}"
	echo "${CMAKE_BINARY}" "${cmakeargs[@]}" "${CMAKE_USE_DIR}"
	"${CMAKE_BINARY}" "${cmakeargs[@]}" "${CMAKE_USE_DIR}" || die "cmake failed"
	popd > /dev/null
}

enable_cmake-utils_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake-utils_src_make "$@"
}

_ninjaopts_from_makeopts() {
	if [[ ${NINJAOPTS+set} == set ]]; then
		return 0
	fi
	local ninjaopts=()
	set -- ${MAKEOPTS}
	while (( $# )); do
		case $1 in
			-j|-l|-k)
				ninjaopts+=( $1 $2 )
				shift 2
				;;
			-j*|-l*|-k*)
				ninjaopts+=( $1 )
				shift 1
				;;
			*) shift ;;
		esac
	done
	export NINJAOPTS="${ninjaopts[*]}"
}

# @FUNCTION: ninja_src_make
# @INTERNAL
# @DESCRIPTION:
# Build the package using ninja generator
ninja_src_make() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -e build.ninja ]] || die "build.ninja not found. Error during configure stage."

	_ninjaopts_from_makeopts

	if [[ "${CMAKE_VERBOSE}" != "OFF" ]]; then
		set -- ninja ${NINJAOPTS} -v "$@"
	else
		set -- ninja ${NINJAOPTS} "$@"
	fi

	echo "$@"
	"$@" || die
}

# @FUNCTION: emake_src_make
# @INTERNAL
# @DESCRIPTION:
# Build the package using make generator
emake_src_make() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -e Makefile ]] || die "Makefile not found. Error during configure stage."

	if [[ "${CMAKE_VERBOSE}" != "OFF" ]]; then
		emake VERBOSE=1 "$@" || die
	else
		emake "$@" || die
	fi

}

# @FUNCTION: cmake-utils_src_make
# @DESCRIPTION:
# Function for building the package. Automatically detects the build type.
# All arguments are passed to emake.
cmake-utils_src_make() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null

	${CMAKE_MAKEFILE_GENERATOR}_src_make "$@"

	popd > /dev/null
}

enable_cmake-utils_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null
	[[ -e CTestTestfile.cmake ]] || { echo "No tests found. Skipping."; return 0 ; }

	[[ -n ${TEST_VERBOSE} ]] && myctestargs+=( --extra-verbose --output-on-failure )

	if ctest "${myctestargs[@]}" "$@" ; then
		einfo "Tests succeeded."
		popd > /dev/null
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
		popd > /dev/null
		return 1
	fi
}

enable_cmake-utils_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null
	DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install "$@" || die "died running ${CMAKE_MAKEFILE_GENERATOR} install"
	popd > /dev/null

	pushd "${S}" > /dev/null
	einstalldocs
	popd > /dev/null
}

# @FUNCTION: cmake-utils_src_prepare
# @DESCRIPTION:
# Apply ebuild and user patches.
cmake-utils_src_prepare() {
	_execute_optionally "src_prepare" "$@"
}

# @FUNCTION: cmake-utils_src_configure
# @DESCRIPTION:
# General function for configuring with cmake. Default behaviour is to start an
# out-of-source build.
cmake-utils_src_configure() {
	_execute_optionally "src_configure" "$@"
}

# @FUNCTION: cmake-utils_src_compile
# @DESCRIPTION:
# General function for compiling with cmake.
# Automatically detects the build type. All arguments are passed to emake.
cmake-utils_src_compile() {
	_execute_optionally "src_compile" "$@"
}

# @FUNCTION: cmake-utils_src_test
# @DESCRIPTION:
# Function for testing the package. Automatically detects the build type.
cmake-utils_src_test() {
	_execute_optionally "src_test" "$@"
}

# @FUNCTION: cmake-utils_src_install
# @DESCRIPTION:
# Function for installing the package. Automatically detects the build type.
cmake-utils_src_install() {
	_execute_optionally "src_install" "$@"
}

# Optionally executes phases based on WANT_CMAKE variable/USE flag.
_execute_optionally() {
	local phase="$1" ; shift
	if [[ ${WANT_CMAKE} = always ]]; then
		enable_cmake-utils_${phase} "$@"
	else
		use ${WANT_CMAKE} && enable_cmake-utils_${phase} "$@"
	fi
}

fi
