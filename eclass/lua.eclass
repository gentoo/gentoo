# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: lua.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# Marek Szuba <marecki@gentoo.org>
# @AUTHOR:
# Marek Szuba <marecki@gentoo.org>
# Based on python{,-utils}-r1.eclass by Michał Górny <mgorny@gentoo.org> et al.
# @SUPPORTED_EAPIS: 7
# @BLURB: A common eclass for Lua packages
# @DESCRIPTION:
# A common eclass providing helper functions to build and install
# packages supporting being installed for multiple Lua implementations.
#
# This eclass sets correct IUSE. Modification of REQUIRED_USE has to
# be done by the author of the ebuild (but LUA_REQUIRED_USE is
# provided for convenience, see below). The eclass exports LUA_DEPS
# and LUA_USEDEP so you can create correct dependencies for your
# package easily. It also provides methods to easily run a command for
# each enabled Lua implementation and duplicate the sources for them.
#
# Please note that for the time being this eclass does NOT support luajit.
#
# @EXAMPLE:
# @CODE
# EAPI=7
#
# LUA_COMPAT=( lua5-{1..3} )
#
# inherit lua
#
# [...]
#
# REQUIRED_USE="${LUA_REQUIRED_USE}"
# DEPEND="${LUA_DEPS}"
# RDEPEND="${DEPEND}
#	dev-lua/foo[${LUA_USEDEP}]"
# BDEPEND="virtual/pkgconfig"
#
# lua_src_install() {
#	emake LUA_VERSION="$(lua_get_version)" install
# }
#
# src_install() {
#	lua_foreach_impl lua_src_install
# }
# @CODE

case ${EAPI:-0} in
	0|1|2|3|4|5|6)
		die "Unsupported EAPI=${EAPI} (too old) for ${ECLASS}"
		;;
	7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_LUA_R0} ]]; then

inherit multibuild toolchain-funcs

fi

# @ECLASS-VARIABLE: LUA_COMPAT
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# This variable contains a list of Lua implementations the package
# supports. It must be set before the `inherit' call. It has to be
# an array.
#
# Example:
# @CODE
# LUA_COMPAT=( lua5-1 lua5-2 lua5-3 )
# @CODE
#
# Please note that you can also use bash brace expansion if you like:
# @CODE
# LUA_COMPAT=( lua5-{1..3} )
# @CODE

# @ECLASS-VARIABLE: LUA_COMPAT_OVERRIDE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable can be used when working with ebuilds to override
# the in-ebuild LUA_COMPAT. It is a string listing all
# the implementations which package will be built for. It need be
# specified in the calling environment, and not in ebuilds.
#
# It should be noted that in order to preserve metadata immutability,
# LUA_COMPAT_OVERRIDE does not affect IUSE nor dependencies.
# The state of LUA_TARGETS is ignored, and all the implementations
# in LUA_COMPAT_OVERRIDE are built. Dependencies need to be satisfied
# manually.
#
# Example:
# @CODE
# LUA_COMPAT_OVERRIDE='lua5-2' emerge -1v dev-lua/foo
# @CODE

# @ECLASS-VARIABLE: LUA_REQ_USE
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# The list of USE flags required to be enabled on the chosen Lua
# implementations, formed as a USE-dependency string. It should be valid
# for all implementations in LUA_COMPAT, so it may be necessary to
# use USE defaults.
# This must be set before calling `inherit'.
#
# Example:
# @CODE
# LUA_REQ_USE="deprecated"
# @CODE
#
# It will cause the Lua dependencies to look like:
# @CODE
# lua_targets_luaX-Y? ( dev-lang/lua:X.Y[deprecated] )
# @CODE

# @ECLASS-VARIABLE: BUILD_DIR
# @OUTPUT_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The current build directory. In global scope, it is supposed to
# contain an initial build directory; if unset, it defaults to ${S}.
#
# In functions run by lua_foreach_impl(), the BUILD_DIR is locally
# set to an implementation-specific build directory. That path is
# created through appending a hyphen and the implementation name
# to the final component of the initial BUILD_DIR.
#
# Example value:
# @CODE
# ${WORKDIR}/foo-1.3-lua5-1
# @CODE

# @ECLASS-VARIABLE: ELUA
# @DEFAULT_UNSET
# @DESCRIPTION:
# The executable name of the current Lua interpreter. This variable is set
# automatically in functions called by lua_foreach_impl().
#
# Example value:
# @CODE
# lua5.1
# @CODE

# @ECLASS-VARIABLE: LUA
# @DEFAULT_UNSET
# @DESCRIPTION:
# The absolute path to the current Lua interpreter. This variable is set
# automatically in functions called by lua_foreach_impl().
#
# Example value:
# @CODE
# /usr/bin/lua5.1
# @CODE

# @ECLASS-VARIABLE: LUA_DEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated Lua dependency string for all
# implementations listed in LUA_COMPAT.
#
# Example use:
# @CODE
# RDEPEND="${LUA_DEPS}
#   dev-foo/mydep"
# DEPEND="${RDEPEND}"
# @CODE
#
# Example value:
# @CODE
# lua_targets_lua5-1? ( dev-lang/lua:5.1 )
# lua_targets_lua5-2? ( dev-lang/lua:5.2 )
# @CODE

# @ECLASS-VARIABLE: LUA_REQUIRED_USE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated required-use expression which ensures at
# least one Lua implementation has been enabled.
#
# This expression should be utilized in an ebuild by including it in
# REQUIRED_USE, optionally behind a use flag.
#
# Example use:
# @CODE
# REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
# @CODE
#
# Example value:
# @CODE
# || ( lua_targets_lua5-1 lua_targets_lua5-2 )
# @CODE

# @ECLASS-VARIABLE: LUA_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used to
# depend on another Lua package being built for the same Lua
# implementations.
#
# Example use:
# @CODE
# RDEPEND="dev-lua/foo[${LUA_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# lua_targets_lua5-1(-)?,lua_targets_lua5-2(-)?
# @CODE

if [[ ! ${_LUA_R0} ]]; then

# @FUNCTION: _lua_export
# @USAGE: [<impl>] <variables>...
# @INTERNAL
# @DESCRIPTION:
# Set and export the Lua implementation-relevant variables passed
# as parameters.
#
# The optional first parameter may specify the requested Lua
# implementation (either as LUA_TARGETS value, e.g. lua5-2,
# or an ELUA one, e.g. lua5.2). If no implementation passed,
# the current one will be obtained from ${ELUA}.
_lua_export() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl var

	case "${1}" in
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

				export LUA_CMOD_DIR=${val}
				debug-print "${FUNCNAME}: LUA_CMOD_DIR = ${LUA_CMOD_DIR}"
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

				export LUA_LMOD_DIR=${val}
				debug-print "${FUNCNAME}: LUA_LMOD_DIR = ${LUA_LMOD_DIR}"
				;;
			LUA_PKG_DEP)
				local d
				case ${impl} in
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

# @FUNCTION: _lua_validate_useflags
# @INTERNAL
# @DESCRIPTION:
# Enforce the proper setting of LUA_TARGETS, if LUA_COMPAT_OVERRIDE
# is not in effect. If it is, just warn that the flags will be ignored.
_lua_validate_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${LUA_COMPAT_OVERRIDE} ]]; then
		if [[ ! ${_LUA_COMPAT_OVERRIDE_WARNED} ]]; then
			ewarn "WARNING: LUA_COMPAT_OVERRIDE in effect. The following Lua"
			ewarn "implementations will be enabled:"
			ewarn
			ewarn "	${LUA_COMPAT_OVERRIDE}"
			ewarn
			ewarn "Dependencies won't be satisfied, and LUA_TARGETS will be ignored."
			_LUA_COMPAT_OVERRIDE_WARNED=1
		fi
		# we do not use flags with LCO
		return
	fi

	local i

	for i in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		use "lua_targets_${i}" && return 0
	done

	eerror "No Lua implementation selected for the build. Please add one"
	eerror "of the following values to your LUA_TARGETS"
	eerror "(in make.conf or package.use):"
	eerror
	eerror "${LUA_COMPAT[@]}"
	echo
	die "No supported Lua implementation in LUA_TARGETS."
}

# @FUNCTION: _lua_obtain_impls
# @INTERNAL
# @DESCRIPTION:
# Set up the enabled implementation list.
_lua_obtain_impls() {
	_lua_validate_useflags

	if [[ ${LUA_COMPAT_OVERRIDE} ]]; then
		MULTIBUILD_VARIANTS=( ${LUA_COMPAT_OVERRIDE} )
		return
	fi

	MULTIBUILD_VARIANTS=()

	local impl
	for impl in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		has "${impl}" "${LUA_COMPAT[@]}" && \
		use "lua_targets_${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}


# @FUNCTION: _lua_multibuild_wrapper
# @USAGE: <command> [<args>...]
# @INTERNAL
# @DESCRIPTION:
# Initialize the environment for the Lua implementation selected
# for multibuild.
_lua_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	local -x ELUA LUA
	_lua_export "${MULTIBUILD_VARIANT}" ELUA LUA
	local -x PATH=${PATH} PKG_CONFIG_PATH=${PKG_CONFIG_PATH}
	_lua_wrapper_setup

	"${@}"
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

		# Lua interpreter and compiler
		ln -s "${EPREFIX}"/usr/bin/${ELUA} "${workdir}"/bin/lua || die
		ln -s "${EPREFIX}"/usr/bin/${ELUA/a/ac} "${workdir}"/bin/luac || die

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

# @FUNCTION: lua_copy_sources
# @DESCRIPTION:
# Create a single copy of the package sources for each enabled Lua
# implementation.
#
# The sources are always copied from initial BUILD_DIR (or S if unset)
# to implementation-specific build directory matching BUILD_DIR used by
# lua_foreach_abi().
lua_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_lua_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: lua_foreach_impl
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Run the given command for each of the enabled Lua implementations.
# If additional parameters are passed, they will be passed through
# to the command.
#
# The function will return 0 status if all invocations succeed.
# Otherwise, the return code from first failing invocation will
# be returned.
#
# For each command being run, ELUA, LUA and BUILD_DIR are set
# locally, and the former two are exported to the command environment.
lua_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_lua_obtain_impls

	multibuild_foreach_variant _lua_multibuild_wrapper "${@}"
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

_LUA_R0=1
fi

# @ECLASS-VARIABLE: _LUA_ALL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All supported Lua implementations, most preferred last
_LUA_ALL_IMPLS=(
	lua5-1
	lua5-2
	lua5-3
	lua5-4
)
readonly _LUA_ALL_IMPLS

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

# @FUNCTION: _lua_set_globals
# @INTERNAL
# @DESCRIPTION:
# Sets all the global output variables provided by this eclass.
# This function must be called once, in global scope.
_lua_set_globals() {
	local deps i LUA_PKG_DEP

	_lua_set_impls

	for i in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		_lua_export "${i}" LUA_PKG_DEP
		deps+="lua_targets_${i}? ( ${LUA_PKG_DEP} ) "
	done

	local flags=( "${_LUA_SUPPORTED_IMPLS[@]/#/lua_targets_}" )
	local optflags=${flags[@]/%/(-)?}

	local requse="|| ( ${flags[*]} )"
	local usedep=${optflags// /,}

	if [[ ${LUA_DEPS+1} ]]; then
		# IUSE is magical, so we can't really check it
		# (but we verify LUA_COMPAT already)

		if [[ ${LUA_DEPS} != "${deps}" ]]; then
			eerror "LUA_DEPS have changed between inherits (LUA_REQ_USE?)!"
			eerror "Before: ${LUA_DEPS}"
			eerror "Now   : ${deps}"
			die "LUA_DEPS integrity check failed"
		fi

		# these two are formality -- they depend on LUA_COMPAT only
		if [[ ${LUA_REQUIRED_USE} != ${requse} ]]; then
			eerror "LUA_REQUIRED_USE have changed between inherits!"
			eerror "Before: ${LUA_REQUIRED_USE}"
			eerror "Now   : ${requse}"
			die "LUA_REQUIRED_USE integrity check failed"
		fi

		if [[ ${LUA_USEDEP} != "${usedep}" ]]; then
			eerror "LUA_USEDEP have changed between inherits!"
			eerror "Before: ${LUA_USEDEP}"
			eerror "Now   : ${usedep}"
			die "LUA_USEDEP integrity check failed"
		fi
	else
		IUSE=${flags[*]}

		LUA_DEPS=${deps}
		LUA_REQUIRED_USE=${requse}
		LUA_USEDEP=${usedep}
		readonly LUA_DEPS LUA_REQUIRED_USE
	fi
}

_lua_set_globals
unset -f _lua_set_globals _lua_set_impls
