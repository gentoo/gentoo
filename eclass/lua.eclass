# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: lua.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# Marek Szuba <marecki@gentoo.org>
# @AUTHOR:
# Marek Szuba <marecki@gentoo.org>
# Based on python-r1.eclass by Michał Górny <mgorny@gentoo.org> et al.
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: lua-utils
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
# Note that since this eclass always inherits lua-utils as well, in ebuilds
# using the former there is no need to explicitly inherit the latter in order
# to use helper functions such as lua_get_CFLAGS.
#
# @EXAMPLE:
# @CODE
# EAPI=8
#
# LUA_COMPAT=( lua5-{3..4} )
#
# inherit lua
#
# [...]
#
# REQUIRED_USE="${LUA_REQUIRED_USE}"
# DEPEND="${LUA_DEPS}"
# RDEPEND="${DEPEND}
#     dev-lua/foo[${LUA_USEDEP}]"
# BDEPEND="virtual/pkgconfig"
#
# lua_src_install() {
#     emake LUA_VERSION="$(lua_get_version)" install
# }
#
# src_install() {
#     lua_foreach_impl lua_src_install
# }
# @CODE

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_LUA_ECLASS} ]]; then
_LUA_ECLASS=1

if [[ ${_LUA_SINGLE_ECLASS} ]]; then
	die 'lua.eclass cannot be used with lua-single.eclass.'
fi

inherit multibuild lua-utils

# @ECLASS_VARIABLE: LUA_COMPAT
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# This variable contains a list of Lua implementations the package
# supports. It must be set before the `inherit' call. It has to be
# an array.
#
# Example:
# @CODE
# LUA_COMPAT=( lua5-1 lua5-3 lua5-4 )
# @CODE
#
# Please note that you can also use bash brace expansion if you like:
# @CODE
# LUA_COMPAT=( lua5-{1..3} )
# @CODE

# @ECLASS_VARIABLE: LUA_COMPAT_OVERRIDE
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
# LUA_COMPAT_OVERRIDE='luajit' emerge -1v dev-lua/foo
# @CODE

# @ECLASS_VARIABLE: LUA_REQ_USE
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

# @ECLASS_VARIABLE: BUILD_DIR
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

# @ECLASS_VARIABLE: LUA_DEPS
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
# lua_targets_lua5-3? ( dev-lang/lua:5.3 )
# @CODE

# @ECLASS_VARIABLE: LUA_REQUIRED_USE
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
# || ( lua_targets_lua5-1 lua_targets_lua5-3 )
# @CODE

# @ECLASS_VARIABLE: LUA_USEDEP
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
# lua_targets_lua5-1(-)?,lua_targets_lua5-3(-)?
# @CODE

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
unset -f _lua_set_globals

fi
