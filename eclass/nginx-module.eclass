# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx-module.eclass
# @MAINTAINER:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @AUTHOR:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Provides a common set of functions for building NGINX's dynamic modules
# @DESCRIPTION:
# The nginx-module.eclass automates configuring, building and installing NGINX's
# dynamic modules.  Using this eclass is as simple as calling 'inherit nginx-module'.
# This eclass automatically adds dependencies on www-servers/nginx.
# Additionally, NGINX_MOD_INSTALL_CONF_STUB may be set to automatically generate
# load_module .conf stubs for NGINX.  Henceforth, the terms 'package' and
# 'module' will be used interchangeably to refer to a consumer of
# nginx-module.eclass.
#
# If a part of package's functionality depends on NGINX configuration (e.g. HMAC
# generation support depending on http_ssl module being present), the
# corresponding module's 'config' code should be changed so that the functionality
# in question is either (1) unconditionally enabled/disabled or (2) can be
# toggled with a USE flag.  That is, an ebuild author should deduce whether a
# package actually depends on a particular module or on the underlying
# libraries/APIs.  In the example HMAC case, the module actually requires
# libcrypto, not the http_ssl module, so the ebuild code reflects this by
# patching the module's 'config' file and depending on dev-libs/openssl directly
# using the ngx_mod_link_lib() function.
#
# If the package genuinely depends on first-party NGINX module(s), the helper
# ngx_mod_gen_nginx_dep() might be used to generate the suitable dependency
# string for depending on first-party modules. For more advanced setups,
# ngx_force_module() and ngx_usex_module() might be of interest.
#
# If the module makes use of the ngx_devel_kit (NDK) or any other NGINX
# module, there are two approaches.
#
# If these dependencies are not USE-conditional ones, they should be specified
# in the NGINX_MOD_LINK_MODULES array before inheriting the eclass.  This way,
# the dependencies added to {,R}DEPEND variables.  Additionally, the package is
# linked to shared objects of the specified dependencies.  See the variable
# description for details.
#
# If the dependencies are USE-conditional, they should be specified as usual in
# the relevant *DEPEND variable(s).  Then, before nginx-module_src_compile() is
# called, the dependencies should be linked to by calling the
# ngx_mod_link_module() function.  See the function description for more
# information.
#
# nginx-module.eclass also supports tests provided by the Test::Nginx Perl
# module.  To enable them, set NGINX_MOD_OPENRESTY_TESTS to a non-empty value
# prior to inheriting the eclass and, if necessary, populate the
# NGINX_MOD_TEST_LOAD_ORDER variable.  All the packages specified in
# NGINX_MOD_TEST_LOAD_ORDER are added to BDEPEND.
#
# The code below presents one of the ways the nginx-module.eclass might be used.
#
# Example usage:
# @CODE
# # This module depends on ngx_devel_kit and ngx-lua-module.
# NGINX_MOD_LINK_MODULES=(
#     www-nginx/ngx_devel_kit www-nginx/ngx-lua-module
# )
#
# # Tests utilise Test::Nginx.
# NGINX_MOD_OPENRESTY_TESTS=1
# # We require ngx-lua-module and ngx-echo for tests, but ngx-echo should
# # be loaded first. Otherwise, some tests break.
# NGINX_MOD_TEST_LOAD_ORDER=(
#    www-nginx/ngx-echo
#    www-nginx/ngx-lua-module
# )
# inherit nginx-module
#
# IUSE="iconv"
#
# DEPEND="iconv? ( www-nginx/ngx-iconv )"
# RDEPEND="${DEPEND}"
#
# src_configure() {
#     if use iconv; then
#         ngx_mod_link_module "www-nginx/ngx-iconv"
#         ...
#     fi
#
#     nginx-module_src_configure
# }
# @CODE
#
# EAPI porting notes:
#   - 8 -> 9:
#     * NGINX_MOD_S is removed completely. Eclass die's if its set.
#     * NGINX_MOD_INSTALL_CONF_STUB is enabled unconditionally.

if [[ -z ${_NGINX_MODULE_ECLASS} ]]; then
_NGINX_MODULE_ECLASS=1

case ${EAPI} in
	8) inherit edo eapi9-pipestatus ;;
	9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit flag-o-matic toolchain-funcs

#-----> Generic helper functions <-----

# @FUNCTION: _ngx_mod_toggle_prefix
# @INTERNAL
# @USAGE: <prefix> <word>
# @RETURN: 'word' with 'prefix' removed if present or added if absent
_ngx_mod_toggle_prefix() {
       debug-print-function "${FUNCNAME[0]}" "$@"
       [[ $# -eq 2 ]] || die "${FUNCNAME[0]} must receive exactly two arguments"

       local prefix="$1" word="$2"
       case "${word}" in
               "${prefix}"*)
                       word="${word#"${prefix}"}"
                       ;;
               *)
                       word="${prefix}${word}"
                       ;;
       esac
       printf '%s\n' "${word}"
}

# @FUNCTION: _ngx_mod_assert_argfile_exists
# @INTERNAL
# @USAGE: <argfile>
# @DESCRIPTION:
# Checks whether the specified configure flags file exists and die's with a
# explanatory message otherwise.
_ngx_mod_assert_argfile_exists() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -eq 1 ]] || die "${FUNCNAME[0]} must receive exactly one argument"

	if [[ ! -f "$1" ]]; then
		eerror "The file with NGINX configure flags has not been found at the"
		eerror "following path: \"$1\""
		eerror ""
		eerror "The most probable cause is a stale installation of www-servers/nginx."
		eerror "Please make sure to reemerge NGINX like shown below, and attempt"
		eerror "to emerge this package again."
		eerror ""
		eerror "To reemerge www-servers/nginx, issue the following command."
		eerror "    emerge --ask --oneshot www-servers/nginx"
		eerror ""
		eerror "If a reinstallation of www-servers/nginx still results in this"
		eerror "error, please seek guidance on Gentoo social channels and/or file"
		eerror "a bug as described on Gentoo Wiki."

		die "Unable to find the required NGINX ./configure flags file"
	fi
	return 0
}

# @FUNCTION: _ngx_mod_enforce_module_flags
# @INTERNAL
# @USAGE: <flags var name> <module name> <module state>
# @DESCRIPTION:
# Takes three parameters: (1) the name of the variable holding ./configure flags
# used to build NGINX, (2) the name of the module which needs to be
# enabled/disabled, (3) and the requested state.
#
# Let state be the requested state of the module.  If state > 0, the module is
# enabled, if state < 0, the module is disabled.  If abs(state) == 1, the
# function die's if the specified module is not found, if abs(state) == 2, the
# function does not die and returns 1 in such case.
#
# Let mod be the requested module to be enabled/disabled, let flags be the
# read-write variable holding flags used to build NGINX (those flags will also
# be used to build mod).  mod is enabled/disabled as follows:
#
#     1. Strings corresponding to ./configure flags to set mod in the desired
#     (target_string) and inverse (inverse_string) configurations are
#     constructed.
#
#     2. We iterate over flags.  If we see an element matching target_string, we
#     know that mod is already in its desired configuration and return.  If we
#     see inverse_string, we remove it from flags.  This guarantees that NGINX
#     builds mod in the desired configuration.  This is because NGINX does not
#     allow to specify ./configure flags that repeat default settings, so if we
#     see inverse_string, we know that the default configuration of mod is our
#     desired configuration.
#
#     3. If flags do not contain either target_string or inverse_string, we grep
#     ./configure --help to find out whether the desired configuration is the
#     default and if module is present at all.
#
#     3.1. If we see target_string in the output of ./configure --help, we know
#     that this is the flag that needs to be supplied to get the desired
#     configuration of mod.  We add target_string to flags and return.
#
#     3.2. If we do not see target_string but see inverse_string, we know that
#     the module exists and its default state corresponds to the desired state.
#     We return.
#
#     3.3. If neither target_string nor inverse_string are found, the module
#     does not exist.  If abs(state) == 1, we die.  If abs(state) == 2, we
#     return 1.
_ngx_mod_enforce_module_flags() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -eq 3 ]] || die "${FUNCNAME[0]} must receive exactly three arguments"

	local -n ref_target="$1"
	local mod="$2"
	local state="$3"

	if ! [[ ${state} -ge -2 && ${state} -le 2 && ${state} != 0 ]]; then
		die "${FUNCNAME[0]}: invalid state value: ${state}. Please file a bug"
	fi

	# First, construct target_string and inverse_string.
	local target_string inverse_string
	if [[ ${state} -gt 0 ]]; then
		target_string="--with-${mod}_module"
		inverse_string="--without-${mod}_module"
	else
		target_string="--without-${mod}_module"
		inverse_string="--with-${mod}_module"
	fi

	# Check whether we already have the target_string or inverse_string in
	# the specified flag variable.
	local key
	for key in "${!ref_target[@]}"; do
		case "${ref_target[${key}]}" in
			"${target_string}")
				# We already have the module in the desired configuration,
				# simply return.
				return 0
				;;
			"${inverse_string}")
				# We have a flag that does the opposite of we want: remove the
				# flag and we are done with this module.
				unset 'ref_target[${key}]'
				return 0
				;;
			*)
				# Some other flag -- continue to the next entry in the flags
				# variable.
				continue
				;;
		esac
	done

	# If we are still here, we have not found either target_string or
	# inverse_string in the flags variable.
	#
	# Now, we grep for target_string in ./configure --help output. If we find
	# it, we append target_string to the flags variable. If not, the default
	# state of the module _is_ the desired state (if the module exists), so we
	# do not need to do anything to force module to the requested state.
	local status
	econf_ngx --help |& grep -q -F -- "${target_string}"
	pipestatus
	status=$?
	if [[ ${status} -eq 0 ]]; then
		ref_target+=( "${target_string}" )
		return 0
	elif [[ ${status} -ne 1 ]]; then
		die "grep failed"
	fi

	# Check whether the specified module exists at all.
	econf_ngx --help |& grep -q -F -- "${inverse_string}"
	pipestatus
	status=$?
	if [[ ${status} -eq 0 ]]; then
		# If inverse_string exists, we know that the module is present: we
		# can safely return.
		return 0
	elif [[ ${status} -ne 1 ]]; then
		die "grep failed"
	fi

	if [[ ${state} -ne 2 && ${state} -ne -2 ]]; then
		# Neither target_string, nor inverse_string are found in
		# ./configure --help: either the module genuinely does not exist or
		# something has gone really wrong.
		die "ngx_force_module: module \"${mod}\" not found and '-n' has not been supplied"
	else
		# If we do not die, we just return 1.
		return 1
	fi
}

# @FUNCTION: econf_ngx
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call ./configure, passing the supplied arguments.
# The NGINX's build system consists of many helper scripts, which are executed
# relative to the working directory.  Therefore, the function only supports
# executing the configure script from the current working directory.  This
# function also checks whether the script is executable.  If any of the above
# conditions are not satisfied, the function aborts the build process with
# 'die'.  It also fails if the script itself exits with a non-zero exit code,
# unless the function is called with 'nonfatal'.
# If running ./configure is required, this function should be called.
econf_ngx() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ ! -x ./configure ]] &&
		die "./configure is not present in the current working directory or is not executable"
	if [[ $1 == --help ]]; then
		# For some reason, NGINX ./configure returns 1 if it is used with the
		# '--help' argument.
		#
		# Executing this without edo gets rid of the "Failed to run" message.
		./configure "$@"
		return 0
	fi
	edo ./configure "$@"
}

# @FUNCTION: ngx_mod_pkg_to_sonames
# @USAGE: <package name>
# @RETURN: Null-delimited list of basenames of shared objects corresponding to the supplied package.
# @DESCRIPTION:
# Takes one argument and prints a null-delimited list of basenames of shared
# objects corresponding to the supplied package.
#
# The mapping between a package and shared objects goes as follows.
#
#     1. The package is stripped of category, yielding a plain
#     package name.
#
#     2. The plain package name is then used to lookup into the internal
#     associative array NGX_MOD_TO_SONAME.  If the lookup fails, the build is
#     aborted with 'die'.  'nonfatal' might be used to make the error to find
#     shared objects non-fatal.
#
#     3. The obtained shared objects are printed to the stdout as a
#     null-delimited list.
#
# Example usage:
# @CODE
# # Obtain shared objects provided by www-nginx/ngx-lua-module.
# mypkg=www-nginx/ngx-lua-module
# mapfile -d '' lua-sonames < <(ngx_mod_pkg_to_sonames "${mypkg}")
# @CODE
ngx_mod_pkg_to_sonames() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -ne 1 ]] && die "${FUNCNAME[0]} must receive exactly one argument"

	local pkg="$1"
	local dep_sonames

	# Strip '${CATEGORY}/' from '${CATEGORY}/${PN}'.
	local entry="${pkg#*/}"

	# Obtain the name of the shared object of the package with PN '${entry}' by
	# looking at the corresponding subscript of the NGX_MOD_TO_SONAME array.
	#
	# For example, entry=ngx-lua-module yields
	#     entry="${NGX_MOD_TO_SONAME[ngx-lua-module]}"
	# which yields
	#     entry="ngx_http_lua_module"
	entry="${NGX_MOD_TO_SONAME[${entry}]}"
	[[ -z ${entry} ]] &&
		die -n "No shared objects found for the dependency ${pkg}. Please file a bug"

	# Read comma-separated shared object names into the 'dep_sonames' array.
	IFS=, read -ra dep_sonames <<< "${entry}"
	# Append '.so' to the end of each array member.
	dep_sonames=( "${dep_sonames[@]/%/.so}" )

	# Print null-delimited list of shared objects' basenames to stdout.
	printf "%s\0" "${dep_sonames[@]}"
}

# @FUNCTION: ngx_mod_append_libs
# @USAGE: [<linker flags>...]
# @DESCRIPTION:
# Adds the passed arguments to the list of flags used for the linking the
# module's shared objects.  Flags may be of any form accepted by linker.
# See the nginx_src_install() function in nginx.eclass for more details.
#
# Example usage:
# @CODE
# ngx_mod_append_libs "-L/usr/$(get_libdir)/nginx/modules" \
#		"$("$(tc-getPKG_CONFIG)" --libs luajit)"
# @CODE
ngx_mod_append_libs() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -eq 0 ]] && return 0

	local resp_file="${T}/append-libs-resp-file"

	# Setup the response file. Make sure to do it only once.
	if [[ -z ${_NGX_MOD_RESP_FILE_SET_UP} ]]; then
		touch "${resp_file}" || die "touch failed"
		export _NGINX_GENTOO_MOD_LIBS+=" @${resp_file}"
		declare -g -r _NGX_MOD_RESP_FILE_SET_UP=1
	fi

	# If multiple arguments are passed, expand them as separate words so that
	# printf prints separate arguments on separate lines.
	printf '%s\n' "$@" >> "${resp_file}" || die "printf failed"
}

# @FUNCTION: ngx_mod_setup_link_modules
# @DESCRIPTION:
# Adds necessary linker arguments for linking to other NGINX modules' share
# objects installed in /usr/$(get_libdir)/nginx/modules by calling
# ngx_mod_append_libs().  This function takes no arguments.
#
# This function is called internally by the ngx_mod_link_module() function.
# ngx_mod_setup_link_modules() keeps track whether it has already been called,
# doing nothing if it is called again after the first execution.
ngx_mod_setup_link_modules() {
	debug-print-function "${FUNCNAME[0]}"

	# Check whether this function has already been called.
	[[ -n ${_NGX_MOD_SETUP_LINK_CALLED} ]] && return 0
	declare -g -r _NGX_MOD_SETUP_LINK_CALLED=1
	local moddir
	moddir="${EPREFIX}/usr/$(get_libdir)/nginx/modules"
	# Add 'moddir' to the list of directories search by linker and add 'moddir'
	# to the module's RUNPATH.
	ngx_mod_append_libs "-L${moddir}" "-Wl,-rpath,\${ORIGIN}"
}

# @FUNCTION: ngx_mod_link_module
# @USAGE: <package name>
# @DESCRIPTION:
# Add the required linker flags to link to the shared objects provided by the
# package passed as the argument.  This function automatically calls
# ngx_mod_setup_link_modules(), if it has not been called.  If the specified
# package provides more than one shared object, all of the shared objects are
# linked to.
#
# This function uses the ngx_mod_pkg_to_sonames() function under the hood to map
# package names to shared objects.  If there are no predefined mappings for the
# selected package, the NGX_MOD_TO_SONAME associative array may be changed
# manually, as presented in the following code excerpt.
#
# @CODE
# NGX_MOD_TO_SONAME+=(
#     [www-nginx/ngx-pkg-name]="the_corresponding_soname_without_dot_so_suffix"
# )
# @CODE
#
# See the default value of NGX_MOD_TO_SONAME for examples.
#
# This function might be used to implement USE-conditional dependency on another
# NGINX module.  See the code snipped below for an example of such usage.
#
# Example usage:
# @CODE
# inherit nginx-module
#
# DEPEND="iconv? ( www-nginx/ngx-iconv )"
# RDEPEND="${DEPEND}"
#
# src_configure() {
#     if use iconv; then
#         ngx_mod_link_module "www-nginx/ngx-iconv"
#         ...
#     fi
#
#     nginx-module_src_configure
# }
# @CODE
ngx_mod_link_module() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -ne 1 ]] && die "${FUNCNAME[0]} must receive exactly one argument"

	[[ -z ${_NGX_MOD_SETUP_LINK_CALLED} ]] && ngx_mod_setup_link_modules

	# Obtain the shared objects names of the module we want to link to (yes,
	# there might be more than one shared object for a given NGINX module).
	local -a sonames
	mapfile -d '' sonames < <(ngx_mod_pkg_to_sonames "$1")

	# Prepend '-l:' to each shared object name. The colon instructs the linker
	# to link to the given name literally; i.e. '-lmylib' will look for
	# 'libmylib.so', while '-l:mylib' will look for 'mylib'.
	ngx_mod_append_libs "${sonames[@]/#/-l:}"
}

# @FUNCTION: ngx_mod_link_lib
# @USAGE: <pkgconfig module name>
# @DESCRIPTION:
# Adds the necessary CFLAGS and LDFLAGS to link the NGINX module with the
# library specified by its <pkgconfig module name>.  The {C,LD}FLAGS are
# obtained using pkgconfig.  The caller must ensure that pkgconfig has been
# added to BDEPEND.
ngx_mod_link_lib() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -ne 1 ]] && die "${FUNCNAME[0]} must receive exactly one argument"
	local pkgconf
	pkgconf="$(tc-getPKG_CONFIG)"

	"${pkgconf}" --exists "$1" || die "The pkgconfig library $1 does not exist"

	append-cflags "$("${pkgconf}" --cflags "$1")"
	ngx_mod_append_libs "$("${pkgconf}" --libs "$1")"
}

# @FUNCTION: ngx_gen_dep
# @USAGE: <module name> [<module name>...]
# @DESCRIPTION:
# Generates dependency string on the specified first-party NGINX module(s) in
# the proper format and prints it to stdout.  Each specified module may
# optionally terminate with a 4-style use dependency default state.  If the
# 4-style default state is not specified, '(-)' is inserted by default.
#
# The dependencies on the respective subsystems are added automatically.  For
# example, the following invocation:
# @CODE
# ngx_gen_dep http_rewrite
# @CODE
# generates something like
# @CODE
# www-servers/nginx:*[http(-),nginx_modules_http_rewrite(-)]
# @CODE
#
# Example:
# @CODE
# # If the SSL functionality is enabled, we require either the stream_ssl or
# # http_ssl module to be enabled in NGINX. If http_ssl is not available, we
# # assume the respective functionality is on.
# RDEPEND="
#     ssl? (
#         || (
#             $(ngx_gen_dep 'http_ssl(+)' stream_ssl)
#         )
#     )
# "
# @CODE
ngx_gen_dep() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -lt 1 ]] && die "${FUNCNAME[0]} must receive at least one argument"

	local mod subsys state out=
	for mod; do
		# Check if the 4-style dependency specification is used.
		if [[ ${mod} = *\([+-]\) ]]; then
			# Trim the modname before the 4-style spec to get the spec itself.
			state="(${mod##*\(}"
			# Get the modname without the trailing '(+)' or '(-)'.
			mod="${mod%%\(*}"
		else
			state='(-)'
		fi
		subsys="${mod%%_*}"
		out+=" www-servers/nginx:*[${subsys}${state},nginx_modules_${mod}${state}]"
	done

	printf '%s\n' "${out}"
}

# @FUNCTION: ngx_force_module
# @USAGE: [-t] <module> [<module>...]
# @DESCRIPTION:
# Enable or disable the specified first-party NGINX module(s).  To disable a
# module, prefix it with a bang: '!'.  If the same module is supplied multiple
# times, the later module overrides the previous ones.
#
# If the '-t' option is specified, the not found module is not treated as an
# error and is instead ignored.  If '-t' is not specified, if the module is not
# found, the build is aborted with die.  The option might be useful for newer or
# older modules, that might not be present in all NGINX versions.
#
# Example:
# @CODE
# # Force enable the http_ssl module.
# ngx_force_module http_ssl
#
# # Force disable the stream_ssl module
# ngx_force_module !stream_ssl
#
# # The following call overrides the first call, forcing http_ssl off.
# ngx_force_module !http_ssl
#
# # Do not die if http_foo_bar is not found, but do try to force enable it if
# # present.
# ngx_force_module -t http_foo_bar
# @CODE
ngx_force_module() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -ge 1 ]] ||
		die "${FUNCNAME[0]} must receive one or more non-option arguments"
	_ngx_mod_assert_argfile_exists "${_NGX_MOD_CONFIG_FLAGS_FILE}"

	local nonfatal=0
	if [[ $1 = '-t' ]]; then
		nonfatal=1
		shift
		[[ $# -ge 1 ]] ||
			die "${FUNCNAME[0]} must receive one or more non-option arguments"
	fi

	local mod
	local offstate=-1 onstate=1
	if [[ ${nonfatal} -eq 1 ]]; then
		offstate=-2
		onstate=2
	fi

	for mod; do
		if [[ ${mod:0:1} = '!' ]]; then
			mod="${mod#\!}"
			_NGX_MOD_FORCED_MODULES[${mod}]="${offstate}"
		else
			_NGX_MOD_FORCED_MODULES[${mod}]="${onstate}"
		fi
	done
}

# @FUNCTION: ngx_usex_module
# @USAGE: [-n] [-t] <use flag> <module> [<module>...]
# @DESCRIPTION:
# Disables or enables the specified first-party NGINX module(s) based on
# the specified USE flag.
#
# Let myflag be the specified USE flag.  If 'use myflag' is true, passes all
# specified modules to ngx_force_module().  If 'use myflag' is false and '-n'
# has not been specified, passes the inversion of all specified modules to
# ngx_force_module().  For the accepted module syntax refer to
# ngx_force_module() description.
#
# By default, if any of the specified modules do not exist, the build is
# aborted.  This can be overriden by supplying '-t'.  See ngx_force_module()
# for behaviour when this flag is supplied.
#
# Example:
# @CODE
# # Enable the http_fastcgi and http_uwsgi if and only if our fastcgi USE flag is
# # enabled. Otherwise, disables http_fastcgi and http_uwsgi.
# ngx_usex_module fastcgi http_fastcgi http_uwsgi
#
# # Enable http_ssl and disable http_rewrite if USE=lazy is set. If USE=-lazy is
# # set, this is equivalent to 'ngx_force_module !http_ssl !http_rewrite'
# ngx_usex_module lazy http_ssl !http_rewrite
#
# # The following is equivalent to
# #    use !ssl && ngx_force_module  stream_pass !stream_ssl
# #    use  ssl && ngx_force_module !stream_pass  stream_ssl
# ngx_usex_module !ssl stream_pass !stream_ssl
#
# # The following is equivalent to
# #    use imap && ngx_force_module mail_imap mail_smtp
# ngx_usex_module -n imap mail_imap mail_smtp
#
# # The following is equivalent to
# #    use !fancy && ngx_force_module -t http_gd http_autoindex
# ngx_usex_module -n -t !fancy http_gd http_autoindex
# @CODE
ngx_usex_module() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	local noinverse=0 nonfatal=0
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-n)
				noinverse=1
				;;
			-t)
				nonfatal=1
				;;
			*)
				break
				;;
		esac
		shift
	done
	[[ $# -ge 2 ]] || die "${FUNCNAME[0]} must receive two or more non-option arguments"

	local module useflag="$1"
	shift

	for module; do
		if ! use "${useflag}"; then
			# If '-n' is passed, do not do anything since 'use myflag' is false.
			[[ ${noinverse} -eq 1 ]] && return 0

			module="$(_ngx_mod_toggle_prefix '!' "${module}")"
		fi

		if [[ ${nonfatal} -eq 1 ]]; then
			ngx_force_module -t "${module}"
		else
			ngx_force_module "${module}"
		fi
	done
}

#-----> ebuild-defined variables <-----

# @ECLASS_VARIABLE: NGINX_MOD_S
# @DEPRECATED: S
# @DESCRIPTION:
# This variable is deprecated in EAPI 8 and banned in EAPI 9.  ${S} must be used
# directly instead.
#
# Deprecated description:
# Holds the path to the module source directory, used in various phase
# functions.  If unset at the time of inherit, defaults to ${S}.
if [[ -n ${NGINX_MOD_S} ]]; then
	case "${EAPI}" in
		8)
			eqawarn "\${NGINX_MOD_S} will be removed in EAPI 9 and must not be used."
			eqawarn "Use \${S} directly instead."
			# Backwards compatibility stub for modules redefining module's
			# source path via ${NGINX_MOD_S}.
			S="${NGINX_MOD_S}"
			;;
		*)
			die "\${NGINX_MOD_S} has been removed in EAPI 9. Use \${S} directly instead."
			;;
	esac
fi

# @ECLASS_VARIABLE: NGINX_MOD_CONFIG_DIR
# @DESCRIPTION:
# Holds the path of the directory containing the config script relative to the
# module source directory specified by the ${S} variable.  If unset at the time
# of inherit, defaults to "" (an empty string, meaning the config script is
# located at the root of the module source directory).
#
# For example, in www-nginx/njs, S="${WORKDIR}/${P}" and
# NGINX_MOD_CONFIG_DIR="nginx".
: "${NGINX_MOD_CONFIG_DIR=""}"

# @ECLASS_VARIABLE: NGINX_S
# @INTERNAL
# @DESCRIPTION:
# Path of the fake NGINX build environment directory where the actual build will
# be performed.  In this directory, symbolic links to NGINX's build system and
# NGINX's headers are created in the nginx-module_src_prepare() phase function.
NGINX_S="${WORKDIR}/nginx"

# @ECLASS_VARIABLE: _NGX_MOD_CONFIG_FLAGS_FILE
# @INTERNAL
# @DESCRIPTION:
# Holds the path to the file containing NUL-separated ./configure flags used to
# build www-servers/nginx.
_NGX_MOD_CONFIG_FLAGS_FILE="${BROOT}/usr/src/nginx/configure-flags"

# @ECLASS_VARIABLE: _NGX_MOD_FORCED_MODULES
# @INTERNAL
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An associative array containing first-party NGINX modules forced on or off by
# a call to ngx_force_module().  See the description of
# _ngx_mod_enforce_module_flags() for the valid values of each key stored in
# this array.
declare -g -A _NGX_MOD_FORCED_MODULES=()

# @ECLASS_VARIABLE: NGINX_MOD_SHARED_OBJECTS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An array containing the basenames of all compiled shared objects (with the
# extension ".so").  For some modules, may consist of more than one shared
# object.
#
# This variable is set by the nginx-module_src_compile() phase function.  Its
# contents are undefined before the function has been called.
#
# Example value:
# @CODE
# ngx_http_lua_module.so
# @CODE

# @ECLASS_VARIABLE: NGX_MOD_TO_SONAME
# @DESCRIPTION:
# An associative array that maps NGINX module package names to their shared
# object names.  For example, 'ngx-lua-module' is mapped to
# 'ngx_http_lua_module'.  The shared objects are specified without the '.so'
# suffix.  May be changed/appended to at any time by an ebuild to override/add
# shared object mappings.
declare -g -A NGX_MOD_TO_SONAME+=(
	[ngx_devel_kit]=ndk_http_module
	[ngx-lua-module]=ngx_http_lua_module
	[ngx-xss]=ngx_http_xss_filter_module
	[ngx-echo]=ngx_http_echo_module
	[ngx-memc]=ngx_http_memc_module
	[ngx-eval]=ngx_http_eval_module
	[ngx-set-misc]=ngx_http_set_misc_module
	[ngx-headers-more]=ngx_http_headers_more_filter_module
	[ngx-iconv]=ngx_http_iconv_module
	[ngx-srcache]=ngx_http_srcache_filter_module
	[ngx-lua-upstream]=ngx_http_lua_upstream_module
)

# @ECLASS_VARIABLE: NGINX_MOD_LINK_MODULES
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to package names of the NGINX module dependencies of this module.  This
# array must be set prior to inheriting the eclass.
#
# All the modules specified in this array are added to DEPEND and RDEPEND.  This
# might be disabled by setting NGINX_MOD_OVERRIDE_LINK_DEPEND to a non-empty
# value.  Additionally, the listed modules are added to the NEEDED sections of
# the current module's shared objects, i.e. the current module is dynamically
# linked to the shared objects corresponding to packages specified in
# NGINX_MOD_LINK_MODULES.
#
# Each element of the array specifies a dependency of an ebuild.  An entry
# consists of a category followed by a package name: ${CATEGORY}/${PN}.
#
# To determine the shared object corresponding to an entry, the eclass looks up
# the respective mapping, specified in the NGX_MOD_TO_SONAME array (see the
# array description for more information).  If no match is found, the build is
# aborted with 'die'.
#
# Example usage:
# @CODE
# # This module depends on both NDK and ngx-lua-module.
# NGINX_MOD_LINK_MODULES=(
#     www-nginx/ngx_devel_kit
#     www-nginx/ngx-lua-module
# )
# inherit nginx-module
# @CODE

# @ECLASS_VARIABLE: NGINX_MOD_OVERRIDE_LINK_DEPEND
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to a non-empty value prior to inheriting the eclass so that the modules
# listed in NGINX_MOD_LINK_MODULES are not automatically added to DEPEND and
# RDEPEND.

# @ECLASS_VARIABLE: NGINX_MOD_OPENRESTY_TESTS
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to non-empty value to enable prior to inheriting the eclass to enable the
# tests via the Test::Nginx (dev-perl/Test-Nginx) testing scaffold. See the
# description of the NGINX_MOD_TEST_LOAD_ORDER variable for more details.

# @ECLASS_VARIABLE: NGINX_MOD_TEST_DIR
# @DESCRIPTION:
# Set to directory containing tests relative to ${S} before calling
# nginx-module_src_test() to override the default directory where tests for this
# package are stored.  If NGINX_MOD_OPENRESTY_TESTS is not set, has no effect.
# Defaults to "t".
: "${NGINX_MOD_TEST_DIR:=t}"

# @ECLASS_VARIABLE: NGINX_MOD_TEST_LOAD_ORDER
# @PRE_INHERIT
# @DESCRIPTION:
# If NGINX_MOD_OPENRESTY_TESTS is set to a non-empty value, this array specifies
# simultaneously the test dependencies of the current module and, since NGINX is
# sensitive to the order of module loading, their load order.  As a special
# workaround, the current module could also be specified as an entry in order to
# force a specific load order.  If the current module is not listed in this
# array, it is loaded first, before all the modules specified in this array.
#
# All the modules specified in this array, barring the current module, are added
# to test BDEPEND.  This behaviour may be disabled by setting the
# NGINX_MOD_OVERRIDE_TEST_BDEPEND variable to a non-empty value.
#
# The format of each entry is the same as in the NGINX_MOD_LINK_MODULES
# variable.  See its description for details.
#
# The shared object names obtained from each entry are then used to populate the
# TEST_NGINX_LOAD_MODULES environment variable.  TEST_NGINX_LOAD_MODULES
# instructs Test::Nginx in what order and which shared objects should be loaded
# during tests.
#
# If NGINX_MOD_OPENRESTY_TESTS is not set, this variable has no effect.
#
# If NGINX_MOD_OVERRIDE_TEST_BDEPEND is not set, this array must be set prior to
# inheriting the eclass to populate BDEPEND.  In any case, this variable must
# ultimately be set before nginx-module_src_test() is called.
#
# Example:
# @CODE
# NGINX_MOD_OPENRESTY_TESTS=1
# NGINX_MOD_TEST_LOAD_ORDER=(
#     www-nginx/ngx-lua-module www-nginx/ngx-eval
#     www-nginx/{my-cool-module,my-another-module}
# )
# @CODE

# @ECLASS_VARIABLE: NGINX_MOD_OVERRIDE_TEST_BDEPEND
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to a non-empty value prior to inheriting the eclass so that the modules
# listed in NGINX_MOD_TEST_LOAD_ORDER are not automatically added to BDEPEND.
# Has no effect if either NGINX_MOD_OPENRESTY_TESTS or NGINX_MOD_TEST_LOAD_ORDER
# are not set.

# @ECLASS_VARIABLE: NGINX_MOD_INSTALL_CONF_STUB
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to a non-empty value before calling nginx-module_src_install() to generate
# and install load_module .conf stub(s) for the package.  See
# nginx-module_src_install() for details.
#
# In EAPI 9, the functionality is enabled unconditionally, unless
# NGINX_MOD_DONT_INSTALL_CONF_STUB is set to a non-empty value.
[[ ${EAPI} != 8 ]] && readonly NGINX_MOD_INSTALL_CONF_STUB=1

# @ECLASS_VARIABLE: NGINX_MOD_DONT_INSTALL_CONF_STUB
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to a non-empty value before calling nginx-module_src_install() to NOT
# generate load_module .conf stub(s) for the package.  Setting this variable
# also disables displaying instructions on how to enable the module in
# nginx-module_pkg_postinst().
#
# Setting this might be useful for modules that are not meant to be used
# directly, for example ngx_devel_kit.  See nginx-module_src_install() for
# details.

#-----> *DEPEND stuff <-----

# As per upstream documentation, modules must be rebuilt with each NGINX
# upgrade.
DEPEND="
	www-servers/nginx:=[modules(-)]
"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

if [[ -z ${NGINX_MOD_OVERRIDE_LINK_DEPEND} &&
	${#NGINX_MOD_LINK_MODULES[@]} -gt 0 ]];
then
	DEPEND+=" ${NGINX_MOD_LINK_MODULES[*]}"
	RDEPEND+=" ${NGINX_MOD_LINK_MODULES[*]}"
fi

#-----> Tests setup <-----

# @FUNCTION: _ngx_mod_set_test_env
# @INTERNAL
# @DESCRIPTION:
# Sets global variables like IUSE and BDEPEND for OpenResty Test::Nginx-based
# tests.
_ngx_mod_set_test_env() {
	IUSE="test"
	RESTRICT="!test? ( test )"
	BDEPEND+=" test? (
		dev-perl/Test-Nginx
	)
	"

	if [[ -z ${NGINX_MOD_OVERRIDE_TEST_BDEPEND} &&
			${#NGINX_MOD_TEST_LOAD_ORDER[@]} -gt 0 ]];
	then
		local entry
		local -a moddep=
		for entry in "${NGINX_MOD_TEST_LOAD_ORDER[@]}"; do
			# If the current entry is equal to the current package, do not add
			# it to BDEPEND.
			[[ ${entry} == "${CATEGORY}/${PN}" ]] && continue

			moddep+=( "${entry}" )
		done
		if [[ ${#moddep[@]} -gt 0 ]]; then
			BDEPEND+="
				test? (
					${moddep[*]}
				)
			"
		fi
	fi
}

[[ -n ${NGINX_MOD_OPENRESTY_TESTS} ]] && _ngx_mod_set_test_env

unset -f _ngx_mod_set_test_env

#-----> Phase functions <-----

# @FUNCTION: nginx-module_src_prepare
# @DESCRIPTION:
# Creates a fake build environment.
#
# In the build environment initialisation part, the following symbolic links are
# created (to not copy files over):
#  - '${NGINX_S}/src' -> '/usr/include/nginx',
#  - '${NGINX_S}/auto' -> '/usr/src/nginx/auto',
#  - '${NGINX_S}/configure' -> '/usr/src/nginx/configure'.
# For additional information of what resides under linked paths, see the
# nginx.eclass source, namely the nginx_src_install() function.
#
# In the end, default_src_prepare() is called.
nginx-module_src_prepare() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	# Set up a fake build environment by creating symlinks to the build system
	# and the headers.
	ebegin "Setting up fake NGINX build environment"
	mkdir "${NGINX_S}" || die "mkdir failed"
	pushd "${NGINX_S}" >/dev/null || die "pushd failed"
	ln -s "${BROOT}/usr/src/nginx/configure" configure || die "ln failed"
	ln -s "${BROOT}/usr/src/nginx/auto" auto || die "ln failed"
	ln -s "${ESYSROOT}/usr/include/nginx" src || die "ln failed"
	popd >/dev/null || die "popd failed"
	eend 0

	ebegin "Determining NGINX configuration on-disk format"

	if [[ -f "${_NGX_MOD_CONFIG_FLAGS_FILE}" ]]; then
		eend 0
		einfo "Using ./configure flags file"
	else
		eend 0
		einfo "Using saved ngx_auto_{config,headers}.h headers"
		pushd "${S}/${NGINX_MOD_CONFIG_DIR}" >/dev/null ||
			die "pushd failed"

		ebegin "Patching module's config"
		# Since NGINX does not guarantee ABI or API stability, we utilise
		# preprocessor macros that were used to compile NGINX itself, to build
		# third party modules. As such, we do not want for the dummy
		# preprocessor macros produced by NGINX build system during module
		# compilation to leak into the building environment. However, we do need
		# to "capture" preprocessor macros set by the module itself, so we are
		# required to somehow get these separately.
		#
		# To achieve that, the following sed script inserts ': >
		# build/ngx_auto_config.h' line at the start of a module's 'config'
		# shell script which gets sourced by NGINX build system midway during
		# configuration. It has an effect of truncating the file containing
		# NGINX preprocessor macros. This results in the file containing only
		# module's macros at the end of the module's configuration.
		#
		# The following command renames the file with module's preprocessor
		# macros to __ngx_gentoo_mod_config.h to be later merged with the system
		# NGINX header into the actual header used during compilation. Due to
		# the fact that executing the config shell script is not the last thing
		# that NGINX build system does during configuration, we can not simply
		# rename the header after the whole configuration, as it may contain
		# other preprocessor macros than only the module's ones.
		sed -i -e '1i\' -e ': > build/ngx_auto_config.h' config ||
			{ eend $? || die "sed failed"; }

		# Add one extra LF before the command in case the 'config' script does
		# not have a trailing newline already.
		printf "\n%s\n" 'mv build/ngx_auto_config.h build/__ngx_gentoo_mod_config.h' \
			>> config
		# We specifically need the $? of printf.
		# shellcheck disable=SC2320
		eend $? || die "printf failed"
		# Get back into the module root and apply patches.
		popd >/dev/null || die "popd failed"
	fi

	default_src_prepare
}

# @FUNCTION: nginx-module_src_configure
# @DESCRIPTION:
# Configures the dynamic module by calling NGINX's ./configure script.
# Custom flags can be supplied as arguments to the function, taking precedence
# over eclass's flags.
#
# This restores ./configure flags, if the respective file is present.
# Otherwise, this function assembles ngx_auto_config.h from the system
# ngx_auto_config.h and __ngx_gentoo_mod_config.h (see
# nginx-module_src_prepare()), and ngx_auto_headers.h from the system
# ngx_auto_headers.h.
#
# Also, sets environment variables and appends necessary libraries if
# NGINX_MOD_LINK_MODULES is set.
nginx-module_src_configure() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	pushd "${NGINX_S}" >/dev/null || die "pushd failed"

	local ngx_mod_flags=()
	if [[ -f "${_NGX_MOD_CONFIG_FLAGS_FILE}" ]]; then
		# Restore the stored configure flags into ngx_mod_flags.
		mapfile -d '' ngx_mod_flags < "${_NGX_MOD_CONFIG_FLAGS_FILE}"

		# When we save compilation flags, NGINX passes all the -l flags to
		# modules too, including stuff like -lperl -lcrypt etc. I am not sure
		# what to do with this yet so for now we just pass the following to
		# limit unnecessary linkage.
		ngx_mod_append_libs "$(test-flags-CC '-Wl,--as-needed')"
	else
		# Otherwise, just replicate a sane subset of configure flags for
		# backwards compatibility.
		ngx_mod_flags=(
			--with-cc="$(tc-getCC)"
			--with-cpp="$(tc-getCPP)"
			--with-ld-opt="${LDFLAGS}"
			--builddir=build
		)

		# NGINX build system adds directories under src/ to the include path based
		# on the specified configuration flags. Since this is the branch where
		# we do not use ./configure flags we have to add the directories to the
		# include path manually.
		#
		# The src/os is added automatically by the auto/unix script and the
		# src/modules directory is included below.
		append-cflags "$(find -H src -mindepth 1 -type d \! \( \( -path 'src/os' -o \
							-path 'src/modules' \) -prune \) -printf '-I %p ')"
	fi

	ngx_mod_flags+=(
		--add-dynamic-module="${S}/${NGINX_MOD_CONFIG_DIR}"
	)

	# The '-isystem' flag is used instead of '-I', so as for the installed
	# (system) modules' headers to be of lower priority than the headers of
	# the currently built module. This only affects the modules that both
	# come with and install their own headers, e.g. ngx_devel_kit.
	append-cflags "-isystem src/modules"

	# Process _NGX_MOD_FORCED_MODULES by iterating over each forced module.
	local mod
	for mod in "${!_NGX_MOD_FORCED_MODULES[@]}"; do
		local state="${_NGX_MOD_FORCED_MODULES[${mod}]}"
		_ngx_mod_enforce_module_flags ngx_mod_flags "${mod}" "${state}"
	done

	# Some NGINX modules that depend on ngx_devel_kit (NDK) check whether the
	# NDK_SRCS variable is non-empty and error out if it is empty or not
	# defined. ngx_devel_kit sets this variable during its build but due to the
	# fact that we build modules separately, i.e. the dependant module is not
	# build alongside NDK, the variable is not exported in the environment and
	# the module halts the build.
	#
	# For all the modules that I have seen, the ones that inspect this variable
	# only check whether NDK_SRCS is non-empty, they do not compare its contents
	# nor alter the variable in any way. Therefore, setting NDK_SRCS to a dummy
	# value works around the build failures for the plugins that do check the
	# variable and, subsequently, has no effect on the modules that do not
	# depend on NDK at all or do not check the variable.
	#
	# This variable is mainly checked by modules developed by OpenResty.
	export NDK_SRCS="ndk.c"

	# Add the required linking flags required for the modules specified in the
	# NGINX_MOD_LINK_MODULES array.
	for mod in "${NGINX_MOD_LINK_MODULES[@]}"; do
		ngx_mod_link_module "${mod}"
	done

	eval "local -a EXTRA_ECONF=( ${EXTRA_ECONF} )"

	# Backwards compatibility shim for header saving setups:
	# Setting the required environment variable to skip the unnecessary
	# execution of certain scripts (see nginx_src_install() in nginx.eclass).
	_NGINX_GENTOO_SKIP_PHASES=1 econf_ngx \
		"${ngx_mod_flags[@]}"	\
		"$@"					\
		"${EXTRA_ECONF[@]}"

	# Backwards compatibility.
	if [[ ! -f "${_NGX_MOD_CONFIG_FLAGS_FILE}" ]]; then
		cat "${ESYSROOT}/usr/include/nginx/ngx_auto_config.h" \
			build/__ngx_gentoo_mod_config.h > build/ngx_auto_config.h ||
			die "cat failed"
		cp "${ESYSROOT}/usr/include/nginx/ngx_auto_headers.h" build ||
				die "cp failed"
	fi

	popd >/dev/null || die "popd failed"
}

# @FUNCTION: nginx-module_src_compile
# @DESCRIPTION:
# Compiles the module(s) by calling "make modules" and fills the
# NGINX_MOD_SHARED_OBJECTS array.
nginx-module_src_compile() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	pushd "${NGINX_S}" >/dev/null || die "pushd failed"

	emake modules
	# Save the basenames of all the compiled modules into the
	# NGINX_MOD_SHARED_OBJECTS array.
	mapfile -d '' NGINX_MOD_SHARED_OBJECTS < \
		<(find -H "${NGINX_S}/build" -maxdepth 1 -type f -name '*.so' -printf '%P\0')

	popd >/dev/null || die "popd failed"
}

# @FUNCTION: nginx-module_src_test
# @DESCRIPTION:
# If NGINX_MOD_OPENRESTY_TESTS is set to a non-empty value, tests the compiled
# module using Test::Nginx (dev-perl/Test-Nginx).
nginx-module_src_test() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ -z ${NGINX_MOD_OPENRESTY_TESTS} ]] && return 0

	# The TEST_NGINX_LOAD_MODULES variable holds the space-separated paths of
	# modules that should be loaded during testing. The variable is set (in
	# order) to the shared object names of the built modules and, then, to
	# shared objects of the dependant modules. Doing this the other way around
	# introduces some test failures for modules like ngx-eval.
	local -x TEST_NGINX_LOAD_MODULES=
	local -a dep_sonames pkg_sonames
	local cur_pkg_in_load_order=

	# The system module directory.
	local moddir
	moddir="${BROOT}/usr/$(get_libdir)/nginx/modules"

	[[ ${#NGINX_MOD_SHARED_OBJECTS[@]} -eq 0 ]] &&
		die "No shared objects found for the currently built module"
	# Prepend each member of the NGINX_MOD_SHARED_OBJECTS array with
	# '${NGINX_S}/build/' and save the array into pkg_sonames.
	pkg_sonames=( "${NGINX_MOD_SHARED_OBJECTS[@]/#/${NGINX_S}/build/}" )

	local pkg
	for pkg in "${NGINX_MOD_TEST_LOAD_ORDER[@]}"; do
		# If the entry is the current package, use the shared objects saved in
		# '${pkg_sonames[@]}' and set the 'cur_pkg_in_load_order' variable.
		if [[ ${pkg} == "${CATEGORY}/${PN}" ]]; then
			TEST_NGINX_LOAD_MODULES+=" ${pkg_sonames[*]}"
			cur_pkg_in_load_order=1
			continue
		fi

		# Save the shared objects names into the dep_sonames array.
		mapfile -d '' dep_sonames < <(ngx_mod_pkg_to_sonames "${pkg}")

		# Prepend each array member with '${moddir}/' (see above) to obtain the
		# absolute path to the shared object.
		dep_sonames=( "${dep_sonames[@]/#/${moddir}/}" )

		# Add the shared objects' paths to the TEST_NGINX_LOAD_MODULES
		# environment variable.
		TEST_NGINX_LOAD_MODULES+=" ${dep_sonames[*]}"
	done
	unset pkg

	# If the current package is not specified in NGINX_MOD_TEST_LOAD_ORDER, load
	# it before its test dependencies.
	if [[ -z ${cur_pkg_in_load_order} ]]; then
		TEST_NGINX_LOAD_MODULES="${pkg_sonames[*]} ${TEST_NGINX_LOAD_MODULES}"
	fi

	# If NGINX_MOD_LINK_MODULES is non-empty, meaning the current module is
	# linked to another module in moddir, set LD_LIBRARY_PATH to the module's
	# directory so that the dynamic loader can find shared objects we depend on.
	[[ ${#NGINX_MOD_LINK_MODULES[@]} -gt 0 ]] &&
		local -x LD_LIBRARY_PATH="${moddir}"

	# Tests break when run in parallel.
	TEST_NGINX_SERVROOT="${T}/servroot" \
		edo prove -j1 -I. -r ./"${NGINX_MOD_TEST_DIR}"
}

# @FUNCTION: nginx-module_src_install
# @DESCRIPTION:
# Installs the compiled module(s) into /usr/${libdir}/nginx/modules.
#
# Autogenerates load_module .conf stub(s) and installs them into
# /etc/nginx/modules-available.  Afterwards, the installed modules can be
# conveniently enabled or disabled by adding or removing symlinks to
# modules-available from /etc/nginx/modules-enabled.  See nginx_src_install() in
# nginx.eclass for more details on how NGINX loads these stubs.
nginx-module_src_install() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	insinto "/usr/$(get_libdir)/nginx/modules"
	doins "${NGINX_S}"/build/*.so

	# Install stub configuration files only if NGINX_MOD_INSTALL_CONF_STUB is
	# set (or EAPI is 9) and NGINX_MOD_DONT_INSTALL_CONF_STUB is not set. The
	# latter is used by modules like ngx_devel_kit which are not meant to be
	# enabled manually.
	if [[ -n ${NGINX_MOD_INSTALL_CONF_STUB} &&
		-z ${NGINX_MOD_DONT_INSTALL_CONF_STUB} ]]; then
		local mod
		local destdir=etc/nginx/modules-available
		insinto "${destdir}"
		# Create configuration stub for every module in NGINX_MOD_SHARED_OBJECTS.
		for mod in "${NGINX_MOD_SHARED_OBJECTS[@]}"; do
			newins - "${mod%.so}.conf" <<- EOF
			# Autogenerated configuration stub.

			load_module modules/${mod};
			EOF
		done
	fi
}

# @FUNCTION: nginx-module_pkg_postinst
# @DESCRIPTION:
# Shows the instructions on how to enable and use the just-compiled module.
nginx-module_pkg_postinst() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	# ngx_devel_kit is an SDK, it does not need to be enabled manually.
	[[ -n ${NGINX_MOD_DONT_INSTALL_CONF_STUB} ]] && return 0

	# We differentiate two situations: (1) autogenerated configuration stub is
	# used, or (2) no configuration stub is generated.
	#
	# In the first case, we advise the user to symlink the configuration stub to
	# /etc/nginx/modules-enabled to enable the module.
	#
	# In the second case, manual configuration change is needed, and we print
	# the instructions on how to change the main NGINX configuration to use the
	# module.
	elog "${PN} has been compiled."
	elog ""
	if [[ -n ${NGINX_MOD_INSTALL_CONF_STUB} ]]; then
		elog "To utilise the module(s), enable it/them by executing the following"
		elog "command(s)"
		elog ""
		for mod in "${NGINX_MOD_SHARED_OBJECTS[@]}"; do
			mod="${mod%.so}.conf"
			elog "    ln -s ../modules-available/${mod} ${EROOT}/etc/nginx/modules-enabled/"
		done
	else
		local mod
		elog "To utilise the module(s), add the following line(s) to your NGINX"
		elog "configuration file, which by default is \"${EROOT}/etc/nginx/nginx.conf\"."
		elog ""
		for mod in "${NGINX_MOD_SHARED_OBJECTS[@]}"; do
			elog "    load_module modules/${mod};"
		done
	fi
}

fi

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_test src_install \
	pkg_postinst
