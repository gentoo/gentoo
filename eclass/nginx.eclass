# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx.eclass
# @MAINTAINER:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @AUTHOR:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: Provides a common set of functions for building the NGINX server
# @DESCRIPTION:
# This eclass automates building, testing and installation of the NGINX server.
# Essentially, apart from the advanced usage, the ebuild must only define 4
# variables prior to inheriting the eclass, everything else is handled by the
# nginx.eclass.
# Refer to the individual variable descriptions for documentation.  The required
# variables are:
#  - NGINX_SUBSYSTEMS
#  - NGINX_MODULES
#  - NGINX_UPDATE_STREAM
#  - NGINX_TESTS_COMMIT
# And 1 optional variable (see description):
#  - NGINX_MISC_FILES

case ${EAPI} in
	8) inherit eapi9-pipestatus ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NGINX_ECLASS} ]]; then
_NGINX_ECLASS=1

# The 60tmpfiles-paths install check produces QA warning if it does not detect
# tmpfiles_process() in pkg_postinst(). Even though the tmpfiles_process() is
# clearly called in nginx_pkg_postinst(), the QA check can not deal with
# exported functions.
# Nonetheless, it is possible to opt out from the QA check by setting the
# TMPFILES_OPTIONAL variable.
TMPFILES_OPTIONAL=1
inherit edo multiprocessing perl-functions systemd toolchain-funcs tmpfiles

#-----> ebuild-defined variables <-----

# @ECLASS_VARIABLE: NGINX_SUBSYSTEMS
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# An array of individual NGINX "servers" or, as they are called in this eclass,
# subsystems.  An optional '+' prefix represents a default-enabled state.
# The variable must be an exact representation of the upstream policy, i.e. the
# subsystems that are enabled-by-default upstream must be prefixed with a '+' in
# this array and the subsystems that are disabled-by-default must not be
# prefixed with a '+'.  Not following this rule will break NGINX build system.  As
# of the time of writing, there are 3 subsystems: "http", "stream", and "mail".
# The naming is the exact representation of ./configure's '--with' and
# '--without' options with the mentioned parts stripped and '+' appended where
# relevant: '--without-http' -> '+http' (means 'http' is enabled by default),
# '--with-stream' -> 'stream', etc.
#
# Example usage:
# @CODE
# NGINX_SUBSYSTEMS=( +http stream mail )
# @CODE
[[ ${#NGINX_SUBSYSTEMS[@]} -eq 0 ]] &&
	die "The required NGINX_SUBSYSTEMS variable is unset or empty"

# @ECLASS_VARIABLE: _NGX_SUBSYSTEMS
# @INTERNAL
# @DESCRIPTION:
# Internal, read-only copy of NGINX_SUBSYSTEMS, used in various places in the
# eclass.
readonly _NGX_SUBSYSTEMS=( "${NGINX_SUBSYSTEMS[@]}" )

# @ECLASS_VARIABLE: NGINX_MODULES
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# An array of bundled NGINX modules names with optional '+' prefix
# representing a default-enabled state.
# The variable must be an exact representation of the upstream policy, i.e. the
# modules that are enabled-by-default upstream must be prefixed with a '+' in
# this array and the modules that are disabled-by-default must not be prefixed
# with a '+'.  Not following this rule will break NGINX build system.
# The naming scheme is exactly the same as used by the ./configure script with
# '--with(out)' and '_module' parts stripped and the '+' prefix applied where
# necessary: '--with-http_v2_module' -> 'http_v2',
# '--without-http_autoindex_module' -> '+http_autoindex',
# '--without-stream_limit_conn_module' -> '+stream_limit_conn', etc.
#
# Example usage:
# @CODE
# NGINX_MODULES=(
# 	+http_rewrite http_ssl +http_gzip
# 	+stream_access
# 	+mail_imap
#	http_{geoip,perl}
# )
# @CODE
[[ ${#NGINX_MODULES[@]} -eq 0 ]] &&
	die "The required NGINX_MODULES variable is unset or empty"

# @ECLASS_VARIABLE: _NGX_MODULES
# @INTERNAL
# @DESCRIPTION:
# Internal, read-only copy of NGINX_MODULES, used in various places in the
# nginx.eclass.
readonly _NGX_MODULES=( "${NGINX_MODULES[@]}" )

# @ECLASS_VARIABLE: NGINX_UPDATE_STREAM
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# This variable must contain the update stream of NGINX.  The list of all
# possible update streams is set by the NGX_UPDATE_STREAMS_LIST variable.  An
# ebuild must not set SLOT manually.  The eclass will automatically set SLOT and
# add blocks on other update streams into RDEPEND variable, based on this
# variable.
# NGINX_UPDATE_STREAM might be set to a special value: 'live'.  Doing this makes
# the eclass fetch the live (latest) version of NGINX from its Git repository.
# This behaviour can be further configured by setting the following variables
# (refer to each variable description for documentation):
#  - NGINX_GIT_URI
#  - NGINX_GIT_TESTS_URI
#
# Example usage:
# @CODE
# NGINX_UPDATE_STREAM=mainline
# @CODE

# @ECLASS_VARIABLE: NGX_UPDATE_STREAMS_LIST
# @DESCRIPTION:
# Read-only array that contains all the possible NGINX update streams.
readonly NGX_UPDATE_STREAMS_LIST=( stable mainline live )

[[ -z ${NGINX_UPDATE_STREAM} ]] &&
	die "The required NGINX_UPDATE_STREAM variable is unset or empty"
has "${NGINX_UPDATE_STREAM}" "${NGX_UPDATE_STREAMS_LIST[@]}" ||
	die "Unknown update stream set in the NGINX_UPDATE_STREAM variable"

[[ ${NGINX_UPDATE_STREAM} == live ]] && inherit git-r3

# @ECLASS_VARIABLE: NGINX_TESTS_COMMIT
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# This variable must contain a valid commit hash of nginx-tests[1] repository. The
# tests for NGINX are unversioned, therefore their snapshot is obtained from the
# specified commit.
# Only in case NGINX_UPDATE_STREAM is set to 'live', this variable might also be
# set exactly to 'live' in order to fetch the latest version of the
# nginx-tests[1] repository.
# [1]: https://github.com/nginx/nginx-tests/
#
# Example usage:
# @CODE
# NGINX_TESTS_COMMIT=345f9b74cd296695b188937b9ade246033476071
# @CODE
[[ -z ${NGINX_TESTS_COMMIT} ]] &&
	die "The required NGINX_TESTS_COMMIT variable is unset or empty"
[[ ${NGINX_TESTS_COMMIT} == live && ${NGINX_UPDATE_STREAM} != live ]] &&
	die "Live tests can not be used with a non-live version of NGINX"

# @ECLASS_VARIABLE: NGINX_GIT_URI
# @DESCRIPTION:
# May be set to an alternative URI of NGINX Git repository for the live
# version to be fetched from.  Defaults to "https://github.com/nginx/nginx".
: "${NGINX_GIT_URI=https://github.com/nginx/nginx}"

# @ECLASS_VARIABLE: NGINX_GIT_TESTS_URI
# @DESCRIPTION:
# May be set to an alternative URI of NGINX tests Git repository for the
# live version to be fetched from.  Defaults to "https://github.com/nginx/nginx-tests".
: "${NGINX_GIT_TESTS_URI=https://github.com/nginx/nginx-tests}"

# @ECLASS_VARIABLE: NGINX_MISC_FILES
# @DEFAULT_UNSET
# @DESCRIPTION:
# This array holds filenames of miscellaneous files in FILESDIR.  The files that
# are specified in this array are installed to various locations, based on their
# file extension.  The "file extension <-> path" mappings are as follows:
#  '.conf'      -> '/etc/nginx'
#  '.service'   ->  systemd unit directory
#  '.initd'     -> '/etc/init.d'
#  '.confd'     -> '/etc/conf.d'
#  '.logrotate' -> '/etc/logrotate.d'
#  '.tmpfiles'  -> '/usr/lib/tmpfiles.d'
# This variable exists to avoid (1) hardcoding specific versions of the files
# that may change due to revisions (the revisions happen rather frequently in
# case of NGINX), (2) repeating the code which installs the files in every
# ebuild, and (3) requiring these miscellaneous files to exist at all.
#
# Example usage:
# @CODE
# NGINX_MISC_FILES=(
#  nginx-r5.initd nginx-r4.conf nginx-r1.confd nginx-{r2.logrotate,r2.service}
# )
# @CODE

# @ECLASS_VARIABLE: OVERRIDE_NGINX_MOD_REQUIRED_USE
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Set this to a non-empty value prior to inheriting the eclass to NOT
# automatically fill the REQUIRED_USE variable with inter-module dependencies.
# For details, see _ngx_set_mod_required_use() function description below.

# @ECLASS_VARIABLE: OVERRIDE_NGINX_MOD_DEPEND
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Set this to a non-empty value prior to inheriting the eclass to NOT
# automatically fill the BDEPEND, DEPEND, and RDEPEND variables with module
# dependencies.
# For details, see _ngx_set_mod_depend() function description below.

# @ECLASS_VARIABLE: OVERRIDE_NGINX_MOD_TEST_DEPEND
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Set this to a non-empty value prior to inheriting the eclass to NOT
# automatically fill the BDEPEND variable with module test dependencies.
# For details, see _ngx_set_mod_test_depend() function description below.

#-----> ebuild setup <-----

# NGINX does not guarantee ABI stability (required by dynamic modules), SLOT is
# set to reflect this.
SLOT="${NGINX_UPDATE_STREAM}/${PV}"
: "${DESCRIPTION=Robust, small and high performance HTTP and reverse proxy server}"
: "${HOMEPAGE=https://nginx.org https://github.com/nginx/nginx}"
if [[ -z ${SRC_URI} ]]; then
	if [[ ${NGINX_UPDATE_STREAM} != live ]]; then
		SRC_URI="https://nginx.org/download/${P}.tar.gz"
	fi
	if [[ ${NGINX_TESTS_COMMIT} != live ]]; then
		SRC_URI+="
			test? (
				https://github.com/nginx/nginx-tests/archive/${NGINX_TESTS_COMMIT}.tar.gz ->
					nginx-tests-${NGINX_TESTS_COMMIT}.tar.gz
			)
		"
	fi
fi
: "${LICENSE=BSD-2}"

# @ECLASS_VARIABLE: NGX_TESTS_S
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Variable set to the work directory of the NGINX tests.
NGX_TESTS_S="${WORKDIR}/nginx-tests-${NGINX_TESTS_COMMIT}"

#-----> Generic helper functions <-----

# @FUNCTION: econf_ngx
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call ./configure, passing the supplied arguments.
# The NGINX build system consists of many helper scripts, which are executed
# relative to the working directory.  Therefore, the function only supports
# executing the ./configure script from the current working directory.  This
# function also checks whether the script is executable.  If any of the above
# conditions are not satisfied, the function aborts the build process with
# 'die'.  It also 'die's if the script itself exits with a non-zero exit code,
# unless the function is called with 'nonfatal'.
# If running ./configure is required, this function should be called.
econf_ngx() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ -x ./configure ]] ||
		die "./configure is not present in the current working directory or is not executable"
	if [[ $1 == --help ]]; then
		# For some reason, NGINX ./configure returns 1 if it is used with the
		# '--help' argument.
		#
		# Executing this without edo gets rid of the "Failed to run" message.
		./configure "$@"
		return
	fi
	edo ./configure "$@"
}

#-----> USE logic <-----

# @FUNCTION: _ngx_populate_iuse
# @INTERNAL
# @DESCRIPTION:
# Populates IUSE with parsed entries from NGINX_SUBSYSTEMS and NGINX_MODULES.
_ngx_populate_iuse() {
	local mod state
	IUSE+=" ${_NGX_SUBSYSTEMS[*]}"
	for mod in "${_NGX_MODULES[@]}"; do
		# SSL should be enabled by default in 2025. http_v2 is enabled because
		# bug 968056.
		if [[ ${mod:0:1} == + || ${mod} == *_ssl || ${mod#+} == http_v2 ]]; then
			state=+
		else
			state=''
		fi
		IUSE+=" ${state}nginx_modules_${mod#+}"
	done
}

IUSE="aio debug libatomic +modules selinux test"
REQUIRED_USE="|| ( ${_NGX_SUBSYSTEMS[*]#+} )"
RESTRICT="!test? ( test )"

_ngx_populate_iuse

unset -f _ngx_populate_iuse

#-----> *DEPEND stuff <-----

BDEPEND="
	test? (
		dev-lang/perl
	)
"

DEPEND="
	acct-group/nginx
	acct-user/nginx
	virtual/libcrypt:=
	libatomic? ( dev-libs/libatomic_ops )
"

RDEPEND="
	${DEPEND}
	app-misc/mime-types[nginx]
	selinux? ( sec-policy/selinux-nginx )
	!app-vim/nginx-syntax
"

IDEPEND="virtual/tmpfiles"


# @FUNCTION: _ngx_set_blocks
# @INTERNAL
# @USAGE: <chosen_update_stream> <possible_upd_stream1> [<possible_upd_stream2>...]
# @DESCRIPTION:
# Set blocks on all the supplied update streams apart from the chosen one.
_ngx_set_blocks() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ $# -ge 2 ]] || die "${FUNCNAME[0]} must receive at least two arguments"
	local chosen candidate
	chosen="$1"
	shift
	for candidate; do
		[[ ${candidate} != "${chosen}" ]] &&
			RDEPEND+=" !${CATEGORY}/${PN}:${candidate}"
	done
}

# Null at the end makes the function also block the legacy unslotted NGINX versions.
_ngx_set_blocks "${NGINX_UPDATE_STREAM}" "${NGX_UPDATE_STREAMS_LIST[@]}" 0


# @FUNCTION: _ngx_set_mod_required_use
# @INTERNAL
# @DESCRIPTION:
# Sets the REQUIRED_USE variable for inter-modules dependencies.  The subscript
# specifies the target module and the value is a comma separated list of the
# modules the subscript depends on.
# This function comes with a predefined associative array of dependencies (that
# should be updated, in case they change, i.e. get added/removed), for each
# ebuild to not redundantly specify these.
# The function adds dependencies only if the corresponding module is specified
# in the NGINX_MODULES variable, defined by the ebuild.  Therefore, it is safe to
# add new modules to the default list, since the respective dependencies will
# not be set for the NGINX versions that do come with the modules in question.
# This function is always executed, unless OVERRIDE_NGINX_MOD_REQUIRED_USE is
# set to a non-empty value (see the variable description).
_ngx_set_mod_required_use() {
	local -A _NGX_DEP_TABLE=(
		[http_v3]=http_ssl
		[http_grpc]=http_v2
	)

	local mod dep_list dep result
	# Iterate over all the indices.
	for mod in "${!_NGX_DEP_TABLE[@]}"; do
		if has "${mod}" "${_NGX_MODULES[@]#+}"; then
			result=''
			# Feed comma-delimited dependencies into the dep_list array.
			IFS=, read -ra dep_list <<< "${_NGX_DEP_TABLE[${mod}]}"
			for dep in "${dep_list[@]}"; do
				has "${dep}" "${_NGX_MODULES[@]#+}" &&
					result+=" nginx_modules_${dep}"
			done
			[[ -n ${result} ]] &&
				REQUIRED_USE+="
					nginx_modules_${mod}? ( ${result} )
				"
		fi
	done
}

[[ -z ${OVERRIDE_NGINX_MOD_REQUIRED_USE} ]] &&
	_ngx_set_mod_required_use

# @FUNCTION: _ngx_set_mod_depend
# @INTERNAL
# @DESCRIPTION:
# Fills the {,B,R}DEPEND variables with external module dependencies.
# This function comes with a predefined associative array of dependencies (that
# should be updated, in case they change, get added/removed), for each ebuild to
# not redundantly specify these.
# The function adds dependencies only if the corresponding module is specified
# in the NGINX_MODULES variable, defined by the ebuild.  Therefore, it is safe to
# add new modules to the default list, since they will not propagate to the
# NGINX versions that do not have the modules in question.
# This function is always executed, unless OVERRIDE_NGINX_MOD_DEPEND is set to a
# non-empty value (see the variable description).
_ngx_set_mod_depend() {
	# The highest common denominator of module dependencies.
	local -A COMMON_DEPEND=(
		[http_image_filter]="media-libs/gd:="
		[http_geoip]="dev-libs/geoip"
		[http_gunzip]="virtual/zlib:="
		[http_gzip]="virtual/zlib:="
		[http_rewrite]="dev-libs/libpcre2:="
		[http_ssl]="dev-libs/openssl:="
		# http_v3 requires NGINX QUIC compatibility layer that uses
		# SSL_CTX_add_custom_ext OpenSSL interface, which was introduced in
		# OpenSSL 1.1.1.
		[http_v3]=">=dev-libs/openssl-1.1.1:="
		[http_xslt]="
			dev-libs/libxml2:=
			dev-libs/libxslt
		"
		[mail_ssl]="dev-libs/openssl:="
		[stream_geoip]="dev-libs/geoip"
		[stream_ssl]="dev-libs/openssl:="
	)
	local COMMON_DEPEND_DEF
	# Bash does not have an easy way to copy an associative array, so its value
	# is obtained using the 'declare' builtin.
	COMMON_DEPEND_DEF="$(declare -p COMMON_DEPEND)"

	local -A _NGX_MOD_BDEPEND=(
		[http_perl]="dev-lang/perl"
	)
	local -A _NGX_MOD_DEPEND="${COMMON_DEPEND_DEF#*=}"
	_NGX_MOD_DEPEND+=(
		[http_perl]="dev-lang/perl"
	)
	local -A _NGX_MOD_RDEPEND="${COMMON_DEPEND_DEF#*=}"
	_NGX_MOD_RDEPEND+=(
		[http_perl]="dev-lang/perl:="
	)

	local mod dep_type dep_table
	# Make dep_table a reference to one of the _NGX_MOD_* variables defined
	# above, then make dep_type itself a reference to the dependency variable.
	for dep_type in {,B,R}DEPEND; do
		declare -n dep_table="_NGX_MOD_${dep_type}"
		declare -n dep_type
		# Iterate over all the indexes (i.e., module names) of the referenced variable.
		for mod in "${!dep_table[@]}"; do
			# If the the module currently being processed is available in the
			# current version of NGINX, add the corresponding dependency line to
			# the respective *DEPEND variable.
			if has "${mod}" "${_NGX_MODULES[@]#+}"; then
				dep_type+=" nginx_modules_${mod}? ( ${dep_table[${mod}]} )"
			fi
		done
		# Reset the 'name reference' attribute.
		declare +n dep_table dep_type
	done
}

[[ -z ${OVERRIDE_NGINX_MOD_DEPEND} ]] &&
	_ngx_set_mod_depend

# @FUNCTION: _ngx_set_mod_test_depend
# @INTERNAL
# @DESCRIPTION:
# Fills the BDEPEND variable with module test dependencies.
# This function comes with a predefined associative array of dependencies (that
# should be updated, in case they change, get added/removed), for each ebuild to
# not redundantly specify these.
# The function adds dependencies only if the corresponding module is specified
# in the NGINX_MODULES variable, defined by the ebuild.  Therefore, it is safe to
# add new modules to the default list, since they will not propagate to the
# NGINX versions that do not have the modules in question.
# This function is always executed, unless OVERRIDE_NGINX_MOD_TEST_DEPEND is set
# to a non-empty value (see the variable description).
_ngx_set_mod_test_depend() {
	# A few notes:
	#  - http_scgi needs SCGI Perl module, which is not packaged by Gentoo,
	#  - http_proxy needs Protocol::Websocket, not packaged by Gentoo.
	local -A _NGX_MOD_TEST_DEP=(
		[http_fastcgi]="dev-perl/FCGI"
		[http_image_filter]="dev-perl/GD"
		[http_memcached]="
			dev-perl/Cache-Memcached
			dev-perl/Cache-Memcached-Fast
			net-misc/memcached
		"
		[http_ssl]="
			dev-perl/IO-Socket-SSL
			dev-perl/Net-SSLeay
		"
		[http_uwsgi]="www-servers/uwsgi[python(-)]"
		[http_v3]="dev-perl/CryptX"
		[mail_ssl]="dev-perl/IO-Socket-SSL"
		[stream_ssl]="dev-perl/IO-Socket-SSL"
	)
	local mod result=
	for mod in "${!_NGX_MOD_TEST_DEP[@]}"; do
		if has "${mod}" "${_NGX_MODULES[@]#+}"; then
			result+=" nginx_modules_${mod}? ( ${_NGX_MOD_TEST_DEP[${mod}]} )"
		fi
	done
	[[ -n ${result} ]] &&
		BDEPEND+=" test? ( ${result} )"
}

[[ -z ${OVERRIDE_NGINX_MOD_TEST_DEPEND} ]] &&
	_ngx_set_mod_test_depend

unset -f _ngx_set_blocks _ngx_set_mod_required_use _ngx_set_mod_depend \
	_ngx_set_mod_test_depend

#-----> Phase functions <-----

# @FUNCTION: nginx_src_unpack
# @DESCRIPTION:
# Unpacks the NGINX sources.  For the live version of NGINX, fetches the tip of
# the Git repository.
nginx_src_unpack() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	if [[ ${NGINX_UPDATE_STREAM} == live ]]; then
		EGIT_REPO_URI="${NGINX_GIT_URI}" git-r3_src_unpack
		# In the Git repo, ./configure script is located in auto/ folder.
		mv "${S}/auto/configure" "${S}/configure" || die "mv failed"
		# Non-live tests for any update stream are taken care of in SRC_URI.
		if use test && [[ ${NGINX_TESTS_COMMIT} == live ]]; then
			EGIT_REPO_URI="${NGINX_GIT_TESTS_URI}" \
			EGIT_CHECKOUT_DIR="${NGX_TESTS_S}" \
				git-r3_src_unpack
		fi
	fi

	default_src_unpack
}

# @FUNCTION: nginx_src_prepare
# @DESCRIPTION:
# Patches NGINX build system files. Afterwards, calls default_src_prepare.
nginx_src_prepare() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	# Append CFLAGS to the link command so that flags like -flto have effect.
	sed -i 's/\$(LINK)/& \\$(CFLAGS)/' auto/make || die "sed failed"

	default_src_prepare
}

# @FUNCTION: nginx_src_configure
# @USAGE: [<args>...]
# @DESCRIPTION:
# Configures NGINX.  The function initialises the default set of configure
# flags, coupled with the USE-conditional ones.  The function also automatically
# disables and enables NGINX modules and subsystems listed in NGINX_MODULES and
# NGINX_SUBSYSTEMS respectively.
# Custom flags can be supplied as arguments to this function, taking precedence
# over eclass flags.
nginx_src_configure() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	local nginx_flags
	nginx_flags=(
		--with-cc="$(tc-getCC)"
		--with-cpp="$(tc-getCPP)"
		--with-ld-opt="${LDFLAGS}"
		--builddir=build
		# NGINX loads modules relative to the prefix, not modules-path
		--prefix="${EPREFIX}/usr/$(get_libdir)/nginx"
		--sbin-path="${EPREFIX}/usr/sbin/nginx"
		--modules-path="${EPREFIX}/usr/$(get_libdir)/nginx/modules"
		--conf-path="${EPREFIX}/etc/nginx/nginx.conf"
		--error-log-path="${EPREFIX}/var/log/nginx/error.log"
		--http-log-path="${EPREFIX}/var/log/nginx/access.log"
		--pid-path="${EPREFIX}/run/nginx/nginx.pid"
		--lock-path="${EPREFIX}/run/lock/nginx.lock"
		--user=nginx
		--group=nginx
		--with-threads
	)

	use aio        && nginx_flags+=( --with-file-aio )
	use debug      && nginx_flags+=( --with-debug )
	use libatomic  && nginx_flags+=( --with-libatomic )
	use modules    && nginx_flags+=( --with-compat )

	# Fix paths for various temporary files.
	local conf _txt
	while read -r conf _txt; do
		conf="${conf%%-temp-path*}"
		conf="${conf#--http-}"
		nginx_flags+=(
			"--http-${conf}-temp-path=${EPREFIX}/var/cache/nginx/${conf//-/_}_temp"
		)
	done < <(econf_ngx --help 2>/dev/null | grep -E -- '--http-([A-Za-z]+-?)+-temp-path')
	unset conf _txt

	# For each subsystem and module we check if they diverge from their default
	# state and, if that is the case, we pass the corresponding flag to the
	# ./configure script.
	# This is done this way because NGINX build system does not understand
	# arguments that set options to their default state, e.g. ./configure does
	# not recognise argument '--with-http_rewrite_module', it understands only
	# '--without-http_rewrite_module', as http_rewrite module is enabled by
	# default.
	local subsys mod def_state use_state
	for subsys in "${_NGX_SUBSYSTEMS[@]}"; do
		use "${subsys#+}"; use_state=$?
		# If the first character is '+' which means the subsystem is
		# enabled-by-default, the default state is 0. If the first character is
		# not '+', the default state is 1 - the subsystem is
		# disabled-by-default.
		[[ ${subsys:0:1} == + ]]; def_state=$?
		# If the USE flag does not correspond to the default value of the
		# subsystem (e.g. a subsystem is default-enabled, but the corresponding
		# USE flag is disabled), we add the respective flag to the list of
		# flags. An example:
		#
		#	- subsystem 'http' is enabled by default. The user does not want the
		#	HTTP server, so they disable the 'http' USE flag. The use_state will
		#	contain '1' and def_state will be equal to '0'. Since these numbers
		#	differ, the flag '--without-http' will be passed to the configure
		#	script.
		if [[ ${use_state} -ne ${def_state} ]]; then
			nginx_flags+=( "$(use_with "${subsys#+}")" )
		fi
	done
	# The same as the above, but for modules.
	for mod in "${_NGX_MODULES[@]}"; do
		use "nginx_modules_${mod#+}"; use_state=$?
		[[ ${mod:0:1} == + ]]; def_state=$?
		# A few more examples, this time with modules:
		#
		#   - Sadly, module 'http_v2' is not enabled by default. A user has
		#   absolutely no need for HTTP/2, and, logically, does not enable the
		#   corresponding 'nginx_modules_http_v2' USE flag. As such,
		#   use_state will be '1' and so will be def_state. The former yields
		#   '1', as the USE flag is disabled and the latter equals to '1' as the
		#   'http_v2' module does not have a '+' in front of it in _NGX_MODULES
		#   array, signifying its default-disabled state. Due to default state
		#   being equal to the USE state, no flag will be passed to ./configure
		#   and the 'http_v2' module is not built.
		#
		#   - Module 'http_ssl' providing SSL/TLS is disabled by default. But,
		#   fortunately, the corresponding 'nginx_modules_http_ssl' USE flag is
		#   appended to IUSE as a default enabled one, since everyone should be
		#   using TLS in 2024 (I guess it will be 2025 by the time this is
		#   merged! Merry Christmas, everybody)! The user decides to leave the
		#   USE flag on to leverage the immense possibilities that encryption
		#   offers. Therefore, use_state will contain 0, meaning that the USE
		#   flag is, in fact, enabled. def_state, on the other hand, will be
		#   '1', as no '+' is present in front of 'http_ssl' in the _NGX_MODULES
		#   array. This denotes the fact that 'http_ssl' is disabled by default
		#   upstream, but the corresponding USE flag is enabled by default in
		#   Gentoo. Since use_state and def_state are not equal, which means
		#   that the default and the actual state are different,
		#   '--with-http_ssl_module' is passed to the ./configure script.
		if [[ ${use_state} -ne ${def_state} ]]; then
			nginx_flags+=( "$(use_with "nginx_modules_${mod#+}" "${mod#+}_module")" )
		fi
	done
	unset subsys mod def_state use_state

	# Handle arguments containing quoted whitespace.
	eval "local -a EXTRA_ECONF=( ${EXTRA_ECONF} )"

	# You never know when bug #286772 may get you.
	LC_ALL=C LANG=C econf_ngx	\
		"${nginx_flags[@]}"		\
		"$@"					\
		"${EXTRA_ECONF[@]}"

	sed -E -i \
		-e '/^\s*LIB= \\$/ d' \
		-e '/^\s*INSTALLSITEMAN3DIR= \\$/ d' \
			build/Makefile || die "sed failed"
}

# @FUNCTION: nginx_src_compile
# @DESCRIPTION:
# Compiles NGINX, setting the correct installation directories for the
# Perl-related files.
nginx_src_compile() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	PERL_MM_OPT='INSTALLDIRS=vendor' emake
}

# @FUNCTION: nginx_src_test
# @DESCRIPTION:
# Performs tests on the compiled NGINX binary, using Perl's prove.
nginx_src_test() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	pushd "${NGX_TESTS_S}" >/dev/null || die "pushd failed"
	# For uwsgi tests, NGINX needs uwsgi's Python plugin. uwsgi installs Python
	# plugins concatenated with a Python version, for example "python312".
	#
	# These plugins must be loaded manually via a command line argument
	# '--plugin PLUGIN_NAME'. NGINX tries '--plugin python' and '--plugin
	# python3', both fail, as the installed uwsgi plugins contain a *full*
	# Python version.
	#
	# To circumvent this issue, we create a temporary fake binary directory with
	# a shell script that executes "uwsgi_python${PYTHON_VERSION}". Upon
	# execution, uwsgi_python* automatically loads the corresponding Python
	# plugin, working around the problem.

	# The old PATH is saved to be restored later, after the tests have finished.
	local old_PATH="${PATH}"

	if in_iuse nginx_modules_http_uwsgi && use nginx_modules_http_uwsgi; then
		mkdir "${T}/fakebin" || die "mkdir failed"
		pushd "${T}/fakebin" >/dev/null || die "pushd failed"

		local -a UWSGI_TARGETS
		# Finds all the "uwsgi_python${PYTHON_VERSION}" in /usr/{,s}bin, which
		# are symlinks to uwsgi.
		mapfile -d '' UWSGI_TARGETS < \
			<(find -H "${BROOT}"/usr/{,s}bin -type l -name 'uwsgi_python*' -print0)
		# We do not care about the specific Python version, we use the first
		# one we that is found.
		[[ ${#UWSGI_TARGETS[@]} -eq 0 ]] &&
			die "No uwsgi with Python support found"
		# A small script is created and PATH is mangled, so that the tests use
		# Python-enabled uwsgi, instead of the default one. The path to uwsgi is
		# quoted in case it contains interesting characters. The stderr is
		# redirected to /dev/null, since, by default, uwsgi prints redundant
		# "Implicit plugin requested" messages.
		cat > uwsgi <<- EOF || die "cat failed"
			#!/bin/sh
			exec ${UWSGI_TARGETS[0]@Q} "\$@" 2>/dev/null
		EOF
		chmod +x uwsgi || die "chmod failed"

		# "${T}/fakebin" is prepended to PATH so that our interceptor script is
		# executed, instead of real uwsgi.
		PATH="${T}/fakebin:${PATH}"
		popd >/dev/null || die "popd failed"
	fi

	TEST_NGINX_BINARY="${S}/build/nginx" \
		edo prove -j "$(makeopts_jobs)" .

	PATH="${old_PATH}"
	popd >/dev/null || die "popd failed"
}

# @FUNCTION: nginx_src_install
# @DESCRIPTION:
# Installs NGINX, including miscellaneous directories under '/var' and
# documentation.  Vimfiles from 'contrib/vim' are also installed by this
# function.  All the files specified in the NGINX_MISC_FILES array are installed
# in their respective directories.
# If 'modules' USE flag is enabled, the build system (the './configure' script
# and the scripts in the 'auto/' directory) is installed into '/usr/src/nginx'
# and NGINX headers into '/usr/include/nginx'.
nginx_src_install() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	emake DESTDIR="${ED}" install
	keepdir "/usr/$(get_libdir)/nginx/modules"

	keepdir /var/log/nginx
	# Set the proper permissions on /var/log/nginx to mitigate CVE-2016-1247
	# (bug #605008).
	fperms 0750 /var/log/nginx
	fowners root:nginx /var/log/nginx
	# NGINX desperately wants to *install* its pidfile (and some web pages).
	# Unfortunately, we can not let it do this...
	rm -r "${ED}/run" "${ED}/usr/$(get_libdir)/nginx/html" || die "rm failed"
	# The default directory for serving web content.
	keepdir /var/www

	# Clean /etc/nginx from unneeded files and move the directory to
	# /usr/share/nginx.
	pushd "${ED}/etc/nginx" >/dev/null || die "pushd failed"
	# mime-types* are provided by app-misc/mime-types[nginx], .default config
	# files are redundant due to CONFIG_PROTECT. As for nginx.conf, we ship our
	# own config file.
	rm -- *.default mime.types nginx.conf || die "rm failed"
	# fastcgi.conf is almost identical to fastcgi_params barring the
	# SCRIPT_FILENAME param. Rename fastcgi.conf to fastcgi_params to have
	# consistent *_params files. See bug 966799.
	mv fastcgi.conf fastcgi_params || die "mv failed"
	popd >/dev/null || die "Returning to the previous directory failed"

	dodir /usr/share/nginx
	# Move all miscellaneous bundled files apart from *_params from /etc/nginx
	# to /usr/share/nginx.
	find "${ED}/etc/nginx" -type f -not -iname '*_params' -print0 |
		xargs -0 -I{} mv {} "${ED}/usr/share/nginx"
	pipestatus || die "find failed"

	insinto /usr/share/nginx
	if [[ ${NGINX_UPDATE_STREAM} != live ]]; then
		dodoc CHANGES*
		doins html/*.html
	else
		# The Git version has a slightly different file structure.
		doins docs/html/*.html
	fi
	dodoc LICENSE README*
	doman build/nginx.8

	# Install miscellaneous files in the proper directories, based on their file
	# extension (see the description of the NGINX_MISC_FILES variable).
	local mfile
	for mfile in "${NGINX_MISC_FILES[@]}"; do
		case "${mfile}" in
			*.conf)
				insinto /etc/nginx
				newins "${FILESDIR}/${mfile}" nginx.conf
				;;
			*.service)
				systemd_newunit "${FILESDIR}/${mfile}" nginx.service
				;;
			*.initd)
				exeinto /etc/init.d
				newexe "${FILESDIR}/${mfile}" nginx
				;;
			*.confd)
				insinto /etc/conf.d
				newins "${FILESDIR}/${mfile}" nginx
				;;
			*.logrotate)
				insinto /etc/logrotate.d
				newins "${FILESDIR}/${mfile}" nginx
				;;
			*.tmpfiles)
				newtmpfiles "${FILESDIR}/${mfile}" "${PN}-tmp.conf"
				;;
			*)
				die "Unknown file in NGINX_MISC_FILES: ${mfile}. Please file a bug"
				;;
		esac
	done

	# Install vimfiles from 'contrib/vim'.
	insinto /usr/share/vim/vimfiles
	doins -r contrib/vim/*

	if in_iuse nginx_modules_http_perl && use nginx_modules_http_perl; then
		perl_delete_module_manpages
		perl_delete_localpod
		perl_fix_packlist
	fi

	# For the rationale of the following, see nginx-module.eclass.
	if use modules; then
		# Install the headers into /usr/include/nginx.
		insinto /usr/include/nginx
		doins -r src/*
		find "${ED}/usr/include/nginx" -type f -not -name '*.h' -delete ||
			die "find failed"
		find "${ED}/usr/include/nginx" -type d -empty -delete ||
			die "find failed"
		# Install the auto-generated headers with #define's to not handle the
		# saving and restoration of configuration flags. This is needed for the
		# compilation of dynamic modules, since NGINX does not guarantee API
		# stability.
		insinto /usr/include/nginx
		doins build/ngx_auto_{config,headers}.h
		# The directory where third-party modules should save their own headers.
		keepdir /usr/include/nginx/modules

		# Allow pluging arbitrary libraries (linker flags, more accurately) via
		# the _NGINX_GENTOO_MOD_LIBS environment variable.
		sed -i -e '/"$ngx_module_link" = DYNAMIC/ a\' \
			-e 'ngx_module_libs="$ngx_module_libs ${_NGINX_GENTOO_MOD_LIBS}"' \
			auto/module || die "sed failed"

		# Copy the build system of NGINX to /usr/src/nginx.
		insinto /usr/src/nginx
		doins -r auto

		# Disable several checks if the _NGINX_GENTOO_SKIP_PHASES variable is
		# set to a non-empty value during the invocation of ./configure script.
		# This is done since (1) these scripts do not have any effect on the
		# build process of third-party modules and (2) they considerably
		# increase configuration time.
		sed -E -i \
			's#^\s*\. auto/(unix|summary)$# \
			[ -z "${_NGINX_GENTOO_SKIP_PHASES}" ] \&\& &#' \
			configure || die "sed failed"

		# The last statement in ./configure is [ -z "${_NGINX_GENTOO... ]. If
		# _NGINX_GENTOO_SKIP_PHASES is non-empty, it evaluates to false and the
		# whole ./configure script exits with a non-zero exit status. 'exit 0'
		# is appended to the end of the script to always exit with a zero exit
		# status, regardless of what the last statement evaluates to.
		echo 'exit 0' >> configure || die "echo failed"
		exeinto /usr/src/nginx
		doexe configure

		# Install the @nginx-module-rebuild set, which groups all the packages
		# that have NGINX in BDEPEND, i.e. third-party modules.
		insinto /usr/share/portage/config/sets
		newins - nginx-modules.conf <<- EOF
			[nginx-modules-rebuild]
			class = portage.sets.dbapi.VariableSet
			variable = BDEPEND
			includes = ${CATEGORY}/${PN}
		EOF
	fi
}

# @FUNCTION: nginx_pkg_postinst
# @DESCRIPTION:
# Shows various warnings and informational messages to a user.  Calls
# tmpfiles_process() to process the installed tmpfiles.
nginx_pkg_postinst() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	if use modules && [[ ${NGINX_UPDATE_STREAM} == live &&
			${REPLACING_VERSIONS} == *9999* ]]; then
		ewarn "The live NGINX package is used with modules enabled."
		elog "NGINX does not have a stable API or ABI, therefore it is"
		elog "necessary for the exact version used to compile a module"
		elog "to match the one used at runtime to load the module."
		elog "To be able to use NGINX modules compiled against the"
		elog "previous version of NGINX, they must be rebuilt manually."
		elog "Run 'emerge @nginx-module-rebuild' to rebuild all NGINX modules."
	fi
	local file
	for file in "${NGINX_MISC_FILES[@]}"; do
		if [[ ${file} == *.tmpfiles ]]; then
			tmpfiles_process "${PN}-tmp.conf"
			break
		fi
	done
}

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_test \
	src_install pkg_postinst
