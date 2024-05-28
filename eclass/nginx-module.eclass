# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx-module.eclass
# @MAINTAINER:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @AUTHOR:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: Provides a common set of functions for building NGINX's dynamic modules
# @DESCRIPTION:
# The nginx-module.eclass automates configuring, building and installing NGINX's
# dynamic modules.  Using this eclass is as simple as calling 'inherit nginx-module'.
# This eclass automatically adds dependencies on www-servers/nginx.  Henceforth,
# the terms 'package' and 'module' will be used interchangeably to refer to a
# consumer of nginx-module.eclass.
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
# using the ngx_mod_append_libs() function.
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
# If the dependencies are USE-conditional, they should be specified as
# usual in the relevant *DEPEND variable(s).  Then, before
# nginx-module_src_configure() is called, the dependencies should be linked to by
# calling the ngx_mod_link_module() function.  See the function description for
# more information.
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
#     if use iconv; Then
#         ngx_mod_link_module "www-nginx/ngx-iconv"
#         ...
#     fi
#
#     nginx-module_src_configure
# }
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NGINX_MODULE_ECLASS} ]]; then
_NGINX_MODULE_ECLASS=1

inherit edo flag-o-matic toolchain-funcs

#-----> Generic helper functions <-----

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
	nonfatal edo ./configure "$@"
	# For some reason, NGINX's ./configure returns 1 if it is used with the
	# '--help' argument.
	if [[ $? -ne 0 && "$1" != --help ]]; then
		die -n "./configure ${*@Q} failed"
	fi
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
# This function has no effect after nginx-module_src_configure() has been
# called.
#
# Example usage:
# @CODE
# ngx_mod_append_libs "-L/usr/$(get_libdir)/nginx/modules" \
#		"$("$(tc-getPKG_CONFIG)" --libs luajit)"
# @CODE
ngx_mod_append_libs() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -eq 0 ]] && return 0

	export _NGINX_GENTOO_MOD_LIBS="${_NGINX_GENTOO_MOD_LIBS} $*"
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
	# Add 'moddir' to the list of directories search by linker.
	ngx_mod_append_libs "-L${moddir}"

	# The string passed to ngx_mod_append_libs undergoes the following
	# transformations by NGINX build system (the str variable denotes the
	# original string and 'modname' represents the name of the current module):
	#         0. Given the value of 'str':
	#             $ echo "${str}"
	#             -Wl,-rpath,'\''\$\${ORIGIN}'\''
	#
	#         1. In auto/module, line 93:
	#             eval ${modname}_libs=\'$str\'.
	#         yields
	#             modname_libs='-Wl,-rpath,'\''\$\${ORIGIN}'\'''
	#         which can be logically separated into
	#             (a) '-Wl,-rpath,'
	#                 ^
	#                 |
	#       The first original single quote (\'$str\')
	#                                         ^
	#                                         |
	#                                       This one
	#             (b) \' (backslash-escaped semicolon)
	#             (c) '\$\${ORIGIN}'
	#             (d) \'
	#             (e) ''
	#				   ^
	#				   |
	#		The last original single quote (\'$str\')
	#		                                       ^
	#		                                       |
	#		                                   This one
	#         To preserve the string we add literal ' and \' so that the
	#         ORIGIN part does not get expanded.
	#           - (a) expands to
	#               -Wl,-rpath
	#           - (b) expands to
	#               '
	#           - (c) expands to
	#               \$\${ORIGIN}
	#           - (d) expands to
	#               '
	#           - (e) expands to nothing
	#         Thus, after evaluating, the value of modname_libs is the
	#         following.
	#             $ echo "${modname_libs}"
	#             -Wl,-rpath,'\$\${ORIGIN}'
	#
	#         2. In auto/make, line 507:
	#             eval eval ngx_module_libs="\\\"\$${modname}_libs\\\"".
	#         The expansion of parameters and double quotes produces the
	#         following.
	#             \"$modname_libs\"
	#         The first outermost eval obtains the contents of the
	#         ${modname}_libs variable and encloses them in double quotes,
	#         yielding:
	#		      eval ngx_module_libs="-Wl,-rpath,'\$\${ORIGIN}'"
	#         The second innermost eval expands the double-quoted string,
	#         produced by the first eval, stripping backslashes from '$'. The
	#         value of 'ngx_module_libs' is therefore:
	#             $ echo "${ngx_module_libs}"
	#             -Wl,-rpath,'$${ORIGIN}'
	#
	#         3. ngx_module_libs's contents are added to the Makefile. make
	#         expands $var variable references, double dollar is used to
	#         suppress the expanding. Thus, the following is passed to the
	#         shell:
	#             -Wl,-rpath,'${ORIGIN}'
	#
	#         4. Finally, shell expands the single quotes, yielding literal:
	#             -Wl,-rpath,${ORIGIN}
	ngx_mod_append_libs "-Wl,-rpath,'\''"'\$\${ORIGIN}'"'\''"
}

# @FUNCTION: ngx_mod_link_module
# @USAGE: <package name>
# @DESCRIPTION:
# Add the required linker flags to link to the shared objects provided by the
# package passed as the argument.  This function automatically calls
# ngx_mod_setup_link_modules(), if it has not been called.  If the specified
# package provides more than one shared object, all of the shared objects are
# linked to.  As ngx_mod_append_libs(), this function has no effect after
# nginx-module_src_configure has been called.
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

#-----> ebuild-defined variables <-----

# @ECLASS_VARIABLE: NGINX_MOD_S
# @DESCRIPTION:
# Holds the path to the module sources directory, used in the
# nginx-module_src_configure() phase function.  If unset at the time of inherit,
# defaults to ${S}.
: "${NGINX_MOD_S=${S}}"

# The ${S} variable is set to the path of the directory where the actual build
# will be performed. In this directory, symbolic links to NGINX's build system
# and NGINX's headers are created by the nginx-module_src_unpack() phase
# function.
S="${WORKDIR}/nginx"

# @ECLASS_VARIABLE: NGINX_MOD_SHARED_OBJECTS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An array containing the basenames of all compiled shared objects (with the
# extension ".so").  For some modules, may consist of more than one shared
# object.
#
# This variable is set in the nginx-module_src_compile() function.  Its contents
# are undefined before that.
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
# Set to directory containing tests relative to NGINX_MOD_S.  If
# NGINX_MOD_OPENRESTY_TESTS is not set, has no effect.  Defaults to "t".
: "${NGINX_MOD_TEST_DIR:=t}"

# @ECLASS_VARIABLE: NGINX_MOD_TEST_LOAD_ORDER
# @PRE_INHERIT
# @DESCRIPTION:
# If NGINX_MOD_OPENRESTY_TESTS is set to a non-empty value, this array specifies
# simultaneously the test dependencies of the current module and, since NGINX is
# sensitive to the order of module loading, their load order.  As a special
# workaround, the current module could also be specified as an entry in order to
# force a specific load order.  If the current module is not listed in this
# array, it is loaded first, before its test dependencies.
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
# This array must be set prior to inheriting the eclass.  If
# NGINX_MOD_OPENRESTY_TESTS is not set, this variable has no effect.
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
# Sets global variables like IUSE and BDEPEND for tests.
_ngx_mod_set_test_env() {
	IUSE="test"
	RESTRICT="!test? ( test )"
	BDEPEND+=" test? (
		dev-perl/Test-Nginx
		virtual/perl-Test-Harness
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

# @FUNCTION: nginx-module_src_unpack
# @DESCRIPTION:
# Unpacks the sources and sets up the build directory in S=${WORKDIR}/nginx.
# Creates the following symbolic links (to not copy the files over):
#  - '${S}/src' -> '/usr/include/nginx',
#  - '${S}/auto' -> '/usr/src/nginx/auto',
#  - '${S}/configure' -> '/usr/src/nginx/configure'.
# For additional information, see the nginx.eclass source, namely the
# nginx_src_install() function.
nginx-module_src_unpack() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	default_src_unpack
	mkdir nginx || die "mkdir failed"
	ln -s "${BROOT}/usr/src/nginx/configure" nginx/configure || die "ln failed"
	ln -s "${BROOT}/usr/src/nginx/auto" nginx/auto || die "ln failed"
	ln -s "${ESYSROOT}/usr/include/nginx" nginx/src || die "ln failed"
}

# @FUNCTION: nginx-module_src_prepare
# @DESCRIPTION:
# Patches module's initialisation code so that any module's preprocessor
# definitions appear in the separate '__ngx_gentoo_mod_config.h' file inside the
# 'build' directory.  This function also makes module's "config" script clear
# whatever content build/ngx_auto_config.h may have at the time of invocation.
# Then, default_src_prepare() is called.
nginx-module_src_prepare() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	pushd "${NGINX_MOD_S}" >/dev/null || die "pushd failed"
	# Since NGINX does not guarantee ABI or API stability, we utilise
	# preprocessor macros that were used to compile NGINX itself, to build third
	# party modules. As such, we do not want for the dummy preprocessor macros
	# produced by NGINX build system during module compilation to leak into the
	# building environment. However, we do need to "capture" preprocessor macros
	# set by the module itself, so we are required to somehow get these
	# separately.
	#
	# To achieve that, the following sed script inserts ': >
	# build/ngx_auto_config.h' line at the start of a module's 'config' shell
	# script which gets sourced by NGINX build system midway during
	# configuration. It has an effect of truncating the file containing NGINX
	# preprocessor macros. This results in the file containing only module's
	# macros at the end of the module's configuration.
	#
	# The following command renames the file with module's preprocessor macros
	# to __ngx_gentoo_mod_config.h to be later merged with the system NGINX
	# header into the actual header used during compilation. Due to the fact
	# that executing the config shell script is not the last thing that NGINX
	# build system does during configuration, we can not simply rename the
	# header after the whole configuration, as it may contain other preprocessor
	# macros than only the module's ones.
	sed -i -e '1i\' -e ': > build/ngx_auto_config.h' config ||
		die "sed failed"
	echo 'mv build/ngx_auto_config.h build/__ngx_gentoo_mod_config.h' \
		>> config || die "echo failed"
	default_src_prepare
	popd >/dev/null || die "popd failed"
}

# @FUNCTION: nginx-module_src_configure
# @DESCRIPTION:
# Configures the dynamic module by calling NGINX's ./configure script.
# Custom flags can be supplied as arguments to the function, taking precedence
# over eclass's flags.
# This assembles ngx_auto_config.h from the system ngx_auto_config.h and
# __ngx_gentoo_mod_config.h (see nginx-module_src_prepare()), and
# ngx_auto_headers.h from the system ngx_auto_headers.h.
# Also, sets environment variables and appends necessary libraries if
# NGINX_MOD_LINK_MODULES is set.
nginx-module_src_configure() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	local ngx_mod_flags
	ngx_mod_flags=(
		--with-cc="$(tc-getCC)"
		--with-cpp="$(tc-getCPP)"
		# The '-isystem' flag is used instead of '-I', so as for the installed
		# (system) modules' headers to be of lower priority than the headers of
		# the currently built module. This only affects the modules that both
		# come with and install their own headers, e.g. ngx_devel_kit.
		--with-cc-opt="-isystem src/modules"
		--with-ld-opt="${LDFLAGS}"
		--builddir=build
		--add-dynamic-module="${NGINX_MOD_S}"
	)

	# NGINX build system adds directories under src/ to the include path based
	# on the specified configuration flags. Since nginx.eclass does not
	# save/restore the configuration flags, we have to add the directories to
	# the include path manually.
	# The src/os is added automatically by the auto/unix script and the
	# src/modules directory is included by the '--with-cc-opt' configuration
	# flag.
	append-cflags "$(find -H src -mindepth 1 -type d \! \( \( -path 'src/os' -o \
						-path 'src/modules' \) -prune \) -printf '-I %p ')"

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
	if [[ ${#NGINX_MOD_LINK_MODULES[@]} -gt 0 ]]; then
		local mod
		for mod in "${NGINX_MOD_LINK_MODULES[@]}"; do
			ngx_mod_link_module "${mod}"
		done
	fi

	eval "local -a EXTRA_ECONF=( ${EXTRA_ECONF} )"

	# Setting the required environment variable to skip the unnecessary
	# execution of certain scripts (see nginx_src_install() in nginx.eclass).
	_NGINX_GENTOO_SKIP_PHASES=1 econf_ngx \
		"${ngx_mod_flags[@]}"	\
		"$@"					\
		"${EXTRA_ECONF[@]}"

	cat "${ESYSROOT}/usr/include/nginx/ngx_auto_config.h" \
		build/__ngx_gentoo_mod_config.h > build/ngx_auto_config.h ||
		die "cat failed"
	cp "${ESYSROOT}/usr/include/nginx/ngx_auto_headers.h" build ||
		die "cp failed"
}

# @FUNCTION: nginx-module_src_compile
# @DESCRIPTION:
# Compiles the module(s) by calling "make modules" and fills the
# NGINX_MOD_SHARED_OBJECTS array.
nginx-module_src_compile() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	emake modules
	# Save the basenames of all the compiled modules into the
	# NGINX_MOD_SHARED_OBJECTS array.
	mapfile -d '' NGINX_MOD_SHARED_OBJECTS < \
		<(find -H "${S}/build" -maxdepth 1 -type f -name '*.so' -printf '%P\0')
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
	# '${S}/build/' and save the array into pkg_sonames.
	pkg_sonames=( "${NGINX_MOD_SHARED_OBJECTS[@]/#/${S}/build/}" )

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

	pushd "${NGINX_MOD_S}" >/dev/null || die "pushd failed"

	# If NGINX_MOD_LINK_MODULES is non-empty, meaning the current module is
	# linked to another module in moddir, set LD_LIBRARY_PATH to the module's
	# directory so that the dynamic loader can find shared objects we depend on.
	[[ ${#NGINX_MOD_LINK_MODULES[@]} -gt 0 ]] &&
		local -x LD_LIBRARY_PATH="${moddir}"

	# Tests break when run in parallel.
	TEST_NGINX_SERVROOT="${T}/servroot" \
		edo prove -j1 -I. -r ./"${NGINX_MOD_TEST_DIR}"

	popd >/dev/null || die "popd failed"
}

# @FUNCTION: nginx-module_src_install
# @DESCRIPTION:
# Installs the compiled module(s) into /usr/${libdir}/nginx/modules.
nginx-module_src_install() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	insinto "/usr/$(get_libdir)/nginx/modules"
	doins build/*.so
}

# @FUNCTION: nginx-module_pkg_postinst
# @DESCRIPTION:
# Shows the instructions on how to enable and use the just-compiled module.
nginx-module_pkg_postinst() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	# ngx_devel_kit is an SDK, it does not need to be enabled manually.
	[[ ${PN} == ngx_devel_kit ]] && return 0

	local mod

	elog "${PN} has been compiled."
	elog ""
	elog "To utilise the module, add the following line(s) to your NGINX"
	elog "configuration file, which by default is \"${EROOT}/etc/nginx/nginx.conf\"."
	elog ""
	for mod in "${NGINX_MOD_SHARED_OBJECTS[@]}"; do
		elog "    load_module modules/${mod};"
	done
}

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_test \
	src_install pkg_postinst
