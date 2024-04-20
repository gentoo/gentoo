# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: lua-utils.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# Marek Szuba <marecki@gentoo.org>
# @AUTHOR:
# Marek Szuba <marecki@gentoo.org>
# Based on python-utils-r1.eclass by Michał Górny <mgorny@gentoo.org> et al.
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Utility functions for packages with Lua parts
# @DESCRIPTION:
# A utility eclass providing functions to query Lua implementations,
# install Lua modules and scripts.
#
# This eclass neither sets any metadata variables nor exports any phase
# functions. It can be inherited safely.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_LUA_UTILS_ECLASS} ]]; then
_LUA_UTILS_ECLASS=1

inherit toolchain-funcs

# @ECLASS_VARIABLE: _LUA_ALL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All supported Lua implementations, most preferred last
_LUA_ALL_IMPLS=(
	luajit
	lua5-1
	lua5-3
	lua5-4
)
readonly _LUA_ALL_IMPLS

# @ECLASS_VARIABLE: _LUA_HISTORICAL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All historical Lua implementations that are no longer supported.
_LUA_HISTORICAL_IMPLS=(
	lua5-2
)
readonly _LUA_HISTORICAL_IMPLS

# @FUNCTION: _lua_set_impls
# @INTERNAL
# @DESCRIPTION:
# Check LUA_COMPAT for well-formedness and validity, then set
# two global variables:
#
# - _LUA_SUPPORTED_IMPLS containing valid implementations supported
#   by the ebuild (LUA_COMPAT minus dead implementations),
#
# - and _LUA_UNSUPPORTED_IMPLS containing valid implementations that
#   are not supported by the ebuild.
#
# Implementations in both variables are ordered using the pre-defined
# eclass implementation ordering.
#
# This function must only be called once.
_lua_set_impls() {
	local i

	if ! declare -p LUA_COMPAT &>/dev/null; then
		die 'LUA_COMPAT not declared.'
	fi
	if [[ $(declare -p LUA_COMPAT) != "declare -a"* ]]; then
		die 'LUA_COMPAT must be an array.'
	fi

	local supp=() unsupp=()

	for i in "${_LUA_ALL_IMPLS[@]}"; do
		if has "${i}" "${LUA_COMPAT[@]}"; then
			supp+=( "${i}" )
		else
			unsupp+=( "${i}" )
		fi
	done

	if [[ ! ${supp[@]} ]]; then
		die "No supported implementation in LUA_COMPAT."
	fi

	if [[ ${_LUA_SUPPORTED_IMPLS[@]} ]]; then
		# set once already, verify integrity
		if [[ ${_LUA_SUPPORTED_IMPLS[@]} != ${supp[@]} ]]; then
			eerror "Supported impls (LUA_COMPAT) changed between inherits!"
			eerror "Before: ${_LUA_SUPPORTED_IMPLS[*]}"
			eerror "Now   : ${supp[*]}"
			die "_LUA_SUPPORTED_IMPLS integrity check failed"
		fi
		if [[ ${_LUA_UNSUPPORTED_IMPLS[@]} != ${unsupp[@]} ]]; then
			eerror "Unsupported impls changed between inherits!"
			eerror "Before: ${_LUA_UNSUPPORTED_IMPLS[*]}"
			eerror "Now   : ${unsupp[*]}"
			die "_LUA_UNSUPPORTED_IMPLS integrity check failed"
		fi
	else
		_LUA_SUPPORTED_IMPLS=( "${supp[@]}" )
		_LUA_UNSUPPORTED_IMPLS=( "${unsupp[@]}" )
		readonly _LUA_SUPPORTED_IMPLS _LUA_UNSUPPORTED_IMPLS
	fi
}

# @FUNCTION: _lua_wrapper_setup
# @USAGE: [<path> [<impl>]]
# @INTERNAL
# @DESCRIPTION:
# Create proper Lua executables and pkg-config wrappers
# (if available) in the directory named by <path>. Set up PATH
# and PKG_CONFIG_PATH appropriately. <path> defaults to ${T}/${ELUA}.
#
# The wrappers will be created for implementation named by <impl>,
# or for one named by ${ELUA} if no <impl> passed.
#
# If the named directory contains a lua symlink already, it will
# be assumed to contain proper wrappers already and only environment
# setup will be done. If wrapper update is requested, the directory
# shall be removed first.
_lua_wrapper_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	local workdir=${1:-${T}/${ELUA}}
	local impl=${2:-${ELUA}}

	[[ ${workdir} ]] || die "${FUNCNAME}: no workdir specified."
	[[ ${impl} ]] || die "${FUNCNAME}: no impl nor ELUA specified."

	if [[ ! -x ${workdir}/bin/lua ]]; then
		mkdir -p "${workdir}"/{bin,pkgconfig} || die

		# Clean up, in case we were supposed to do a cheap update
		rm -f "${workdir}"/bin/lua{,c} || die
		rm -f "${workdir}"/pkgconfig/lua.pc || die

		local ELUA LUA
		_lua_export "${impl}" ELUA LUA

		# Lua interpreter
		ln -s "${EPREFIX}"/usr/bin/${ELUA} "${workdir}"/bin/lua || die

		# Lua compiler, or a stub for it in case of luajit
		if [[ ${ELUA} == luajit ]]; then
			# Just in case
			ln -s "${EPREFIX}"/bin/true "${workdir}"/bin/luac || die
		else
			ln -s "${EPREFIX}"/usr/bin/${ELUA/a/ac} "${workdir}"/bin/luac || die
		fi

		# pkg-config
		ln -s "${EPREFIX}"/usr/$(get_libdir)/pkgconfig/${ELUA}.pc \
			"${workdir}"/pkgconfig/lua.pc || die
	fi

	# Now, set the environment.
	# But note that ${workdir} may be shared with something else,
	# and thus already on top of PATH.
	if [[ ${PATH##:*} != ${workdir}/bin ]]; then
		PATH=${workdir}/bin${PATH:+:${PATH}}
	fi
	if [[ ${PKG_CONFIG_PATH##:*} != ${workdir}/pkgconfig ]]; then
		PKG_CONFIG_PATH=${workdir}/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}
	fi
	export PATH PKG_CONFIG_PATH
}

# @ECLASS_VARIABLE: ELUA
# @DEFAULT_UNSET
# @DESCRIPTION:
# The executable name of the current Lua interpreter. This variable is set
# automatically in functions called by lua_foreach_impl().
#
# Example value:
# @CODE
# lua5.1
# @CODE

# @ECLASS_VARIABLE: LUA
# @DEFAULT_UNSET
# @DESCRIPTION:
# The absolute path to the current Lua interpreter. This variable is set
# automatically in functions called by lua_foreach_impl().
#
# Example value:
# @CODE
# /usr/bin/lua5.1
# @CODE

# @FUNCTION: _lua_get_library_file
# @USAGE: <impl>
# @INTERNAL
# @DESCRIPTION:
# Get the core part (i.e. without the extension) of the library name,
# with path, of the given Lua implementation.
# Used internally by _lua_export().
_lua_get_library_file() {
	local impl="${1}"
	local libdir libname

	case ${impl} in
		luajit)
			libname=lib$($(tc-getPKG_CONFIG) --variable libname ${impl}) || die
			;;
		lua*)
			libname=lib${impl}
			;;
		*)
			die "Invalid implementation: ${impl}"
			;;
	esac

	libdir=$($(tc-getPKG_CONFIG) --variable libdir ${impl}) || die
	libdir="${libdir#${ESYSROOT#${SYSROOT}}}"

	debug-print "${FUNCNAME}: libdir = ${libdir}, libname = ${libname}"
	echo "${libdir}/${libname}"
}

# @FUNCTION: _lua_export
# @USAGE: [<impl>] <variables>...
# @INTERNAL
# @DESCRIPTION:
# Set and export the Lua implementation-relevant variables passed
# as parameters.
#
# The optional first parameter may specify the requested Lua
# implementation (either as LUA_TARGETS value, e.g. lua5-4,
# or an ELUA one, e.g. lua5.4). If no implementation passed,
# the current one will be obtained from ${ELUA}.
_lua_export() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl var

	case "${1}" in
		luajit)
			impl=${1}
			shift
			;;
		lua*)
			impl=${1/-/.}
			shift
			;;
		*)
			impl=${ELUA}
			if [[ -z ${impl} ]]; then
				die "_lua_export called without a Lua implementation and ELUA is unset"
			fi
			;;
	esac
	debug-print "${FUNCNAME}: implementation: ${impl}"

	for var; do
		case "${var}" in
			ELUA)
				export ELUA=${impl}
				debug-print "${FUNCNAME}: ELUA = ${ELUA}"
				;;
			LUA)
				export LUA="${EPREFIX}"/usr/bin/${impl}
				debug-print "${FUNCNAME}: LUA = ${LUA}"
				;;
			LUA_CFLAGS)
				local val

				val=$($(tc-getPKG_CONFIG) --cflags ${impl}) || die

				export LUA_CFLAGS=${val}
				debug-print "${FUNCNAME}: LUA_CFLAGS = ${LUA_CFLAGS}"
				;;
			LUA_CMOD_DIR)
				local val

				val=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${impl}) || die
				val="${val#${ESYSROOT#${SYSROOT}}}"

				export LUA_CMOD_DIR=${val}
				debug-print "${FUNCNAME}: LUA_CMOD_DIR = ${LUA_CMOD_DIR}"
				;;
			LUA_INCLUDE_DIR)
				local val

				val=$($(tc-getPKG_CONFIG) --variable includedir ${impl}) || die
				val="${val#${ESYSROOT#${SYSROOT}}}"

				export LUA_INCLUDE_DIR=${val}
				debug-print "${FUNCNAME}: LUA_INCLUDE_DIR = ${LUA_INCLUDE_DIR}"
				;;
			LUA_LIBS)
				local val

				val=$($(tc-getPKG_CONFIG) --libs ${impl}) || die

				export LUA_LIBS=${val}
				debug-print "${FUNCNAME}: LUA_LIBS = ${LUA_LIBS}"
				;;
			LUA_LMOD_DIR)
				local val

				val=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${impl}) || die
				val="${val#${ESYSROOT#${SYSROOT}}}"

				export LUA_LMOD_DIR=${val}
				debug-print "${FUNCNAME}: LUA_LMOD_DIR = ${LUA_LMOD_DIR}"
				;;
			LUA_PKG_DEP)
				local d
				case ${impl} in
					luajit)
						LUA_PKG_DEP="dev-lang/luajit:="
						;;
					lua*)
						LUA_PKG_DEP="dev-lang/lua:${impl#lua}"
						;;
					*)
						die "Invalid implementation: ${impl}"
						;;
				esac

				# use-dep
				if [[ ${LUA_REQ_USE} ]]; then
					LUA_PKG_DEP+=[${LUA_REQ_USE}]
				fi

				export LUA_PKG_DEP
				debug-print "${FUNCNAME}: LUA_PKG_DEP = ${LUA_PKG_DEP}"
				;;
			LUA_SHARED_LIB)
				local val=$(_lua_get_library_file ${impl})
				export LUA_SHARED_LIB="${val}".so
				debug-print "${FUNCNAME}: LUA_SHARED_LIB = ${LUA_SHARED_LIB}"
				;;
			LUA_VERSION)
				local val

				val=$($(tc-getPKG_CONFIG) --modversion ${impl}) || die

				export LUA_VERSION=${val}
				debug-print "${FUNCNAME}: LUA_VERSION = ${LUA_VERSION}"
				;;
			*)
				die "_lua_export: unknown variable ${var}"
				;;
		esac
	done
}

# @FUNCTION: lua_enable_tests
# @USAGE: <test-runner> <test-directory>
# @DESCRIPTION:
# Set up IUSE, RESTRICT, BDEPEND and src_test() for running tests
# with the specified test runner.  Also copies the current value
# of RDEPEND to test?-BDEPEND.  The test-runner argument must be one of:
#
# - busted: dev-lua/busted
#
# Additionally, a second argument can be passed after <test-runner>,
# so <test-runner> will use that directory to search for tests.
# If not passed, a default directory of <test-runner> will be used.
#
# - busted: spec
#
# This function is meant as a helper for common use cases, and it only
# takes care of basic setup.  You still need to list additional test
# dependencies manually.  If you have uncommon use case, you should
# not use it and instead enable tests manually.
#
# This function must be called in global scope, after RDEPEND has been
# declared.  Take care not to overwrite the variables set by it.
lua_enable_tests() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -ge 1 ]] || die "${FUNCNAME} takes at least one argument: test-runner (test-directory)"
	local test_directory
	local test_pkg
	case ${1} in
		busted)
			test_directory="${2:-spec}"
			test_pkg="dev-lua/busted"
			if [[ ! ${_LUA_SINGLE_ECLASS} ]]; then
				eval "lua_src_test() {
					busted --lua=\"\${ELUA}\" --output=\"plainTerminal\" \"${test_directory}\" || die \"Tests fail with \${ELUA}\"
				}"
				src_test() {
					lua_foreach_impl lua_src_test
				}
			else
				eval "src_test() {
					busted --lua=\"\${ELUA}\" --output=\"plainTerminal\" \"${test_directory}\" || die \"Tests fail with \${ELUA}\"
				}"
			fi
			;;
		*)
			die "${FUNCNAME}: unsupported argument: ${1}"
	esac

	local test_deps=${RDEPEND}
	if [[ -n ${test_pkg} ]]; then
		if [[ ! ${_LUA_SINGLE_ECLASS} ]]; then
			test_deps+=" ${test_pkg}[${LUA_USEDEP}]"
		else
			test_deps+=" $(lua_gen_cond_dep "
				${test_pkg}[\${LUA_USEDEP}]
			")"
		fi
	fi
	if [[ -n ${test_deps} ]]; then
		IUSE+=" test"
		RESTRICT+=" !test? ( test )"
		BDEPEND+=" test? ( ${test_deps} )"
	fi

	# we need to ensure successful return in case we're called last,
	# otherwise Portage may wrongly assume sourcing failed
	return 0
}

# @FUNCTION: lua_get_CFLAGS
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the compiler flags for building against Lua,
# for the given implementation. If no implementation is provided,
# ${ELUA} will be used.
#
# Please note that this function requires Lua and pkg-config installed,
# and therefore proper build-time dependencies need be added to the ebuild.
lua_get_CFLAGS() {
	debug-print-function ${FUNCNAME} "${@}"

	_lua_export "${@}" LUA_CFLAGS
	echo "${LUA_CFLAGS}"
}

# @FUNCTION: lua_get_cmod_dir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the name of the directory into which compiled Lua
# modules are installed, for the given implementation. If no implementation
# is provided, ${ELUA} will be used.
#
# Please note that this function requires Lua and pkg-config installed,
# and therefore proper build-time dependencies need be added to the ebuild.
lua_get_cmod_dir() {
	debug-print-function ${FUNCNAME} "${@}"

	_lua_export "${@}" LUA_CMOD_DIR
	echo "${LUA_CMOD_DIR}"
}

# @FUNCTION: lua_get_include_dir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the name of the directory containing header files
# of the given Lua implementation. If no implementation is provided,
# ${ELUA} will be used.
#
# Please note that this function requires Lua and pkg-config installed,
# and therefore proper build-time dependencies need be added to the ebuild.
lua_get_include_dir() {
	debug-print-function ${FUNCNAME} "${@}"

	_lua_export "${@}" LUA_INCLUDE_DIR
	echo "${LUA_INCLUDE_DIR}"
}

# @FUNCTION: lua_get_LIBS
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the compiler flags for linking against Lua,
# for the given implementation. If no implementation is provided,
# ${ELUA} will be used.
#
# Please note that this function requires Lua and pkg-config installed,
# and therefore proper build-time dependencies need be added to the ebuild.
lua_get_LIBS() {
	debug-print-function ${FUNCNAME} "${@}"

	_lua_export "${@}" LUA_LIBS
	echo "${LUA_LIBS}"
}

# @FUNCTION: lua_get_lmod_dir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the name of the directory into which native-Lua
# modules are installed, for the given implementation. If no implementation
# is provided, ${ELUA} will be used.
#
# Please note that this function requires Lua and pkg-config installed,
# and therefore proper build-time dependencies need be added to the ebuild.
lua_get_lmod_dir() {
	debug-print-function ${FUNCNAME} "${@}"

	_lua_export "${@}" LUA_LMOD_DIR
	echo "${LUA_LMOD_DIR}"
}

# @FUNCTION: lua_get_shared_lib
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the expected name, with path, of the main shared library
# of the given Lua implementation. If no implementation is provided,
# ${ELUA} will be used.
#
# Note that it is up to the ebuild maintainer to ensure Lua actually
# provides a shared library.
#
# Please note that this function requires Lua and pkg-config installed,
# and therefore proper build-time dependencies need be added to the ebuild.
lua_get_shared_lib() {
	debug-print-function ${FUNCNAME} "${@}"

	_lua_export "${@}" LUA_SHARED_LIB
	echo "${LUA_SHARED_LIB}"
}

# @FUNCTION: lua_get_version
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the full version number of the given Lua implementation.
# If no implementation is provided, ${ELUA} will be used.
#
# Please note that this function requires Lua and pkg-config installed,
# and therefore proper build-time dependencies need be added to the ebuild.
lua_get_version() {
	debug-print-function ${FUNCNAME} "${@}"

	_lua_export "${@}" LUA_VERSION
	echo "${LUA_VERSION}"
}

fi
