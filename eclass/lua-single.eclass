# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: lua-single.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# Marek Szuba <marecki@gentoo.org>
# @AUTHOR:
# Marek Szuba <marecki@gentoo.org>
# Based on python-single-r1.eclass by Michał Górny <mgorny@gentoo.org> et al.
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: lua-utils
# @BLURB: An eclass for Lua packages not installed for multiple implementations.
# @DESCRIPTION:
# An extension of lua.eclass suite for packages which don't support being
# installed for multiple Lua implementations. This mostly includes software
# embedding Lua.
#
# This eclass sets correct IUSE.  It also provides LUA_DEPS
# and LUA_REQUIRED_USE that need to be added to appropriate ebuild
# metadata variables.
#
# The eclass exports LUA_SINGLE_USEDEP that is suitable for depending
# on other packages using the eclass.  Dependencies on packages using
# lua.eclass should be created via lua_gen_cond_dep() function, using
# LUA_USEDEP placeholder.
#
# Please note that packages support multiple Lua implementations
# (using lua.eclass) cannot depend on packages not supporting
# them (using this eclass).
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
# inherit lua-single
#
# [...]
#
# REQUIRED_USE="${LUA_REQUIRED_USE}"
# DEPEND="${LUA_DEPS}"
# RDEPEND="${DEPEND}
#     $(lua_gen_cond_dep '
#         dev-lua/foo[${LUA_USEDEP}]
#     ')
# "
# BDEPEND="virtual/pkgconfig"
#
# # Only need if the setup phase has to do more than just call lua-single_pkg_setup
# pkg_setup() {
#     lua-single_pkg_setup
#     [...]
# }
#
# src_install() {
#     emake LUA_VERSION="$(lua_get_version)" install
# }
# @CODE

case ${EAPI} in
	7|8)
		;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_LUA_SINGLE_R0} ]]; then

if [[ ${_LUA_R0} ]]; then
	die 'lua-single.eclass cannot be used with lua.eclass.'
fi

inherit lua-utils

fi

EXPORT_FUNCTIONS pkg_setup

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

# @ECLASS_VARIABLE: LUA_DEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated Lua dependency string for all
# implementations listed in LUA_COMPAT.
#
# Example use:
# @CODE
# RDEPEND="${LUA_DEPS}
#     dev-foo/mydep"
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

# @ECLASS_VARIABLE: LUA_SINGLE_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used
# to depend on another lua-single package being built for the same
# Lua implementations.
#
# If you need to depend on a multi-impl (lua.eclass) package, use
# lua_gen_cond_dep with LUA_USEDEP placeholder instead.
#
# Example use:
# @CODE
# RDEPEND="dev-lua/foo[${LUA_SINGLE_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# lua_single_target_lua5-1(-)?
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

# @FUNCTION: _lua_single_set_globals
# @INTERNAL
# @DESCRIPTION:
# Sets all the global output variables provided by this eclass.
# This function must be called once, in global scope.
_lua_single_set_globals() {
	_lua_set_impls

	local flags=( "${_LUA_SUPPORTED_IMPLS[@]/#/lua_single_target_}" )

	if [[ ${#_LUA_SUPPORTED_IMPLS[@]} -eq 1 ]]; then
		# if only one implementation is supported, use IUSE defaults
		# to avoid requesting the user to enable it
		IUSE="+${flags[0]}"
	else
		IUSE="${flags[*]}"
	fi

	local requse="^^ ( ${flags[*]} )"
	local single_flags="${flags[@]/%/(-)?}"
	local single_usedep=${single_flags// /,}

	local deps= i LUA_PKG_DEP
	for i in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		_lua_export "${i}" LUA_PKG_DEP
		deps+="lua_single_target_${i}? ( ${LUA_PKG_DEP} ) "
	done

	if [[ ${LUA_DEPS+1} ]]; then
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

		if [[ ${LUA_SINGLE_USEDEP} != "${single_usedep}" ]]; then
			eerror "LUA_SINGLE_USEDEP have changed between inherits!"
			eerror "Before: ${LUA_SINGLE_USEDEP}"
			eerror "Now   : ${single_usedep}"
			die "LUA_SINGLE_USEDEP integrity check failed"
		fi
	else
		LUA_DEPS=${deps}
		LUA_REQUIRED_USE=${requse}
		LUA_SINGLE_USEDEP=${single_usedep}
		LUA_USEDEP='%LUA_USEDEP-NEEDS-TO-BE-USED-IN-LUA_GEN_COND_DEP%'
		readonly LUA_DEPS LUA_REQUIRED_USE LUA_SINGLE_USEDEP LUA_USEDEP
	fi
}

_lua_single_set_globals
unset -f _lua_single_set_globals

if [[ ! ${_LUA_SINGLE_R0} ]]; then

# @FUNCTION: _lua_gen_usedep
# @USAGE: [<pattern>...]
# @INTERNAL
# @DESCRIPTION:
# Output a USE dependency string for Lua implementations which
# are both in LUA_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# The patterns can be fnmatch-style patterns (matched via bash == operator
# against LUA_COMPAT values). Remember to escape or quote the fnmatch
# patterns to prevent accidental shell filename expansion.
#
# This is an internal function used to implement lua_gen_cond_dep.
_lua_gen_usedep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()

	_lua_verify_patterns "${@}"
	for impl in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		if _lua_impl_matches "${impl}" "${@}"; then
			matches+=(
				"lua_single_target_${impl}(-)?"
			)
		fi
	done

	[[ ${matches[@]} ]] || die "No supported implementations match lua_gen_usedep patterns: ${@}"

	local out=${matches[@]}
	echo "${out// /,}"
}

# @FUNCTION: _lua_impl_matches
# @USAGE: <impl> [<pattern>...]
# @INTERNAL
# @DESCRIPTION:
# Check whether the specified <impl> matches at least one
# of the patterns following it. Return 0 if it does, 1 otherwise.
# Matches if no patterns are provided.
#
# <impl> can be in LUA_COMPAT or ELUA form. The patterns can be
# fnmatch-style patterns, e.g. 'lua5*', '..
_lua_impl_matches() {
	[[ ${#} -ge 1 ]] || die "${FUNCNAME}: takes at least 1 parameter"
	[[ ${#} -eq 1 ]] && return 0

	local impl=${1} pattern
	shift

	for pattern; do
		# unify value style to allow lax matching
		if [[ ${impl/./-} == ${pattern/./-} ]]; then
			return 0
		fi
	done

	return 1
}

# @FUNCTION: _lua_verify_patterns
# @USAGE: <pattern>...
# @INTERNAL
# @DESCRIPTION:
# Verify whether the patterns passed to the eclass function are correct
# (i.e. can match any valid implementation).  Dies on wrong pattern.
_lua_verify_patterns() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	for pattern; do
		for impl in "${_LUA_ALL_IMPLS[@]}" "${_LUA_HISTORICAL_IMPLS[@]}"; do
			[[ ${impl} == ${pattern/./-} ]] && continue 2
		done

		die "Invalid implementation pattern: ${pattern}"
	done
}

# @FUNCTION: lua_gen_cond_dep
# @USAGE: <dependency> [<pattern>...]
# @DESCRIPTION:
# Output a list of <dependency>-ies made conditional to USE flags
# of Lua implementations which are both in LUA_COMPAT and match
# any of the patterns passed as the remaining parameters.
#
# The patterns can be fnmatch-style patterns (matched via bash == operator
# against LUA_COMPAT values). Remember to escape or quote the fnmatch
# patterns to prevent accidental shell filename expansion.
#
# In order to enforce USE constraints on the packages, verbatim
# '${LUA_SINGLE_USEDEP}' and '${LUA_USEDEP}' (quoted!) may
# be placed in the dependency specification. It will get expanded within
# the function into a proper USE dependency string.
#
# Example:
# @CODE
# LUA_COMPAT=( lua5-{1..3} )
# RDEPEND="$(lua_gen_cond_dep \
#     'dev-lua/backported_core_module[${LUA_USEDEP}]' lua5-1 lua5-3 )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# RDEPEND="lua_single_target_lua5-1? (
#     dev-lua/backported_core_module[lua_targets_lua5-1(-)?,...] )
#	lua_single_target_lua5-3? (
#     dev-lua/backported_core_module[lua_targets_lua5-3(-)?,...] )"
# @CODE
lua_gen_cond_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()

	local dep=${1}
	shift

	_lua_verify_patterns "${@}"
	for impl in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		if _lua_impl_matches "${impl}" "${@}"; then
			# substitute ${LUA_SINGLE_USEDEP} if used
			# (since lua_gen_usedep() will not return
			#  ${LUA_SINGLE_USEDEP}, the code is run at most once)
			if [[ ${dep} == *'${LUA_SINGLE_USEDEP}'* ]]; then
				local usedep=$(_lua_gen_usedep "${@}")
				dep=${dep//\$\{LUA_SINGLE_USEDEP\}/${usedep}}
			fi
			local multi_usedep="lua_targets_${impl}(-)"

			local subdep=${dep//\$\{LUA_MULTI_USEDEP\}/${multi_usedep}}
			matches+=( "lua_single_target_${impl}? (
				${subdep//\$\{LUA_USEDEP\}/${multi_usedep}} )" )
		fi
	done

	echo "${matches[@]}"
}

# @FUNCTION: lua_gen_impl_dep
# @USAGE: [<requested-use-flags> [<impl-pattern>...]]
# @DESCRIPTION:
# Output a dependency on Lua implementations with the specified USE
# dependency string appended, or no USE dependency string if called
# without the argument (or with empty argument). If any implementation
# patterns are passed, the output dependencies will be generated only
# for the implementations matching them.
#
# The patterns can be fnmatch-style patterns (matched via bash == operator
# against LUA_COMPAT values). Remember to escape or quote the fnmatch
# patterns to prevent accidental shell filename expansion.
#
# Use this function when you need to request different USE flags
# on the Lua interpreter depending on package's USE flags. If you
# only need a single set of interpreter USE flags, just set
# LUA_REQ_USE and use ${LUA_DEPS} globally.
#
# Example:
# @CODE
# LUA_COMPAT=( lua5-{1..3} )
# RDEPEND="foo? ( $(lua_gen_impl_dep 'deprecated(+)' lua5-4 ) )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# RDEPEND="foo? (
#	lua_single_target_lua5-4? ( dev-lang/lua:5.3[deprecated(+)] )
# )"
# @CODE
lua_gen_impl_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl
	local matches=()

	local LUA_REQ_USE=${1}
	shift

	_lua_verify_patterns "${@}"
	for impl in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		if _lua_impl_matches "${impl}" "${@}"; then
			local LUA_PKG_DEP
			_lua_export "${impl}" LUA_PKG_DEP
			matches+=( "lua_single_target_${impl}? ( ${LUA_PKG_DEP} )" )
		fi
	done

	echo "${matches[@]}"
}

# @FUNCTION: lua_setup
# @DESCRIPTION:
# Determine what the selected Lua implementation is and set
# the Lua build environment up for it.
lua_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	unset ELUA

	# support developer override
	if [[ ${LUA_COMPAT_OVERRIDE} ]]; then
		local impls=( ${LUA_COMPAT_OVERRIDE} )
		[[ ${#impls[@]} -eq 1 ]] || die "LUA_COMPAT_OVERRIDE must name exactly one implementation for lua-single"

		ewarn "WARNING: LUA_COMPAT_OVERRIDE in effect. The following Lua"
		ewarn "implementation will be used:"
		ewarn
		ewarn "	${LUA_COMPAT_OVERRIDE}"
		ewarn
		ewarn "Dependencies won't be satisfied, and LUA_SINGLE_TARGET flags will be ignored."

		_lua_export "${impls[0]}" ELUA LUA
		_lua_wrapper_setup
		einfo "Using ${ELUA} to build"
		return
	fi

	local impl
	for impl in "${_LUA_SUPPORTED_IMPLS[@]}"; do
		if use "lua_single_target_${impl}"; then
			if [[ ${ELUA} ]]; then
				eerror "Your LUA_SINGLE_TARGET setting lists more than a single Lua"
				eerror "implementation. Please set it to just one value. If you need"
				eerror "to override the value for a single package, please use package.env"
				eerror "or an equivalent solution (man 5 portage)."
				echo
				die "More than one implementation in LUA_SINGLE_TARGET."
			fi

			_lua_export "${impl}" ELUA LUA
			_lua_wrapper_setup
			einfo "Using ${ELUA} to build"
		fi
	done

	if [[ ! ${ELUA} ]]; then
		eerror "No Lua implementation selected for the build. Please set"
		eerror "the LUA_SINGLE_TARGET variable in your make.conf to one"
		eerror "of the following values:"
		eerror
		eerror "${_LUA_SUPPORTED_IMPLS[@]}"
		echo
		die "No supported Lua implementation in LUA_SINGLE_TARGET."
	fi
}

# @FUNCTION: lua-single_pkg_setup
# @DESCRIPTION:
# Runs lua_setup.
lua-single_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MERGE_TYPE} != binary ]] && lua_setup
}

_LUA_SINGLE_R0=1
fi
