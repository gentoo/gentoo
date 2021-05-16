# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: php-ext-source-r3.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Compile and install standalone PHP extensions.
# @DESCRIPTION:
# A unified interface for compiling and installing standalone PHP
# extensions.

inherit autotools

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install src_test

case ${EAPI:-0} in
	6) inherit eapi7-ver ;;
	7) ;;
	*)
		die "${ECLASS} is not compatible with EAPI=${EAPI}"
esac

# @ECLASS-VARIABLE: PHP_EXT_NAME
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# The extension name. This must be set, otherwise the eclass dies.
# Only automagically set by php-ext-pecl-r3.eclass, so unless your ebuild
# inherits that eclass, you must set this manually before inherit.
[[ -z "${PHP_EXT_NAME}" ]] && \
	die "no extension name specified for the php-ext-source-r3 eclass"

# @ECLASS-VARIABLE: PHP_EXT_INI
# @DESCRIPTION:
# Controls whether or not to add a line to php.ini for the extension.
# Defaults to "yes" and should not be changed in most cases.
[[ -z "${PHP_EXT_INI}" ]] && PHP_EXT_INI="yes"

# @ECLASS-VARIABLE: PHP_EXT_ZENDEXT
# @DESCRIPTION:
# Controls whether the extension is a ZendEngine extension or not.
# Defaults to "no". If you don't know what this is, you don't need it.
[[ -z "${PHP_EXT_ZENDEXT}" ]] && PHP_EXT_ZENDEXT="no"

# @ECLASS-VARIABLE: USE_PHP
# @REQUIRED
# @DESCRIPTION:
# Lists the PHP slots compatible the extension is compatible with.
# Example:
# @CODE
# USE_PHP="php5-6 php7-0"
# @CODE
[[ -z "${USE_PHP}" ]] && \
	die "USE_PHP is not set for the php-ext-source-r3 eclass"

# @ECLASS-VARIABLE: PHP_EXT_OPTIONAL_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set, all of the dependencies added by this eclass will be
# conditional on USE=${PHP_EXT_OPTIONAL_USE}. This is needed when
# ebuilds have to inherit this eclass unconditionally, but only
# actually use it when (for example) the user has USE=php.

# @ECLASS-VARIABLE: PHP_EXT_S
# @DESCRIPTION:
# The relative location of the temporary build directory for the PHP
# extension within the source package. This is useful for packages that
# bundle the PHP extension. Defaults to ${S}.
[[ -z "${PHP_EXT_S}" ]] && PHP_EXT_S="${S}"

# @ECLASS-VARIABLE: PHP_EXT_SAPIS
# @DESCRIPTION:
# A list of SAPIs for which we will install this extension. Formerly
# called PHPSAPILIST. The default includes every SAPI currently used in
# the tree.
[[ -z "${PHP_EXT_SAPIS}" ]] && PHP_EXT_SAPIS="apache2 cli cgi fpm embed phpdbg"

# @ECLASS-VARIABLE: PHP_INI_NAME
# @DESCRIPTION:
# An optional file name of the saved ini file minis the ini extension
# This allows ordering of extensions such that one is loaded before
# or after another.  Defaults to the PHP_EXT_NAME.
# Example (produces 40-foo.ini file):
# @CODE
# PHP_INI_NAME="40-foo"
# @CODE
: ${PHP_INI_NAME:=${PHP_EXT_NAME}}

# @ECLASS-VARIABLE: PHP_EXT_NEEDED_USE
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# A list of USE flags to append to each PHP target selected
# as a valid USE-dependency string.  The value should be valid
# for all targets so USE defaults may be necessary.
# Example:
# @CODE
# PHP_EXT_NEEDED_USE="mysql?,pdo,pcre(+)"
# @CODE
#
# The PHP dependencies will result in:
# @CODE
# php_targets_php7-0? ( dev-lang/php:7.0[mysql?,pdo,pcre(+)] )
# @CODE


# Make sure at least one target is installed. First, start a USE
# conditional like "php?", but only when PHP_EXT_OPTIONAL_USE is
# non-null. The option group "|| (..." is always started here.
REQUIRED_USE="${PHP_EXT_OPTIONAL_USE}${PHP_EXT_OPTIONAL_USE:+? ( }|| ( "
PHPDEPEND="${PHP_EXT_OPTIONAL_USE}${PHP_EXT_OPTIONAL_USE:+? ( } "
for _php_target in ${USE_PHP}; do
	# Now loop through each USE_PHP target and add the corresponding
	# dev-lang/php slot to PHPDEPEND.
	IUSE+=" php_targets_${_php_target}"
	REQUIRED_USE+="php_targets_${_php_target} "
	_php_slot=${_php_target/php}
	_php_slot=${_php_slot/-/.}
	if [[ ${PHP_EXT_NEEDED_USE} ]] ; then
		_php_slot+=[${PHP_EXT_NEEDED_USE}]
	fi
	PHPDEPEND+=" php_targets_${_php_target}? ( dev-lang/php:${_php_slot} )"
done

# Don't pollute the environment with our loop variables.
unset _php_slot _php_target

# Finally, end the optional group that we started before the loop. Close
# the USE-conditional if PHP_EXT_OPTIONAL_USE is non-null.
REQUIRED_USE+=") ${PHP_EXT_OPTIONAL_USE:+ )}"
PHPDEPEND+=" ${PHP_EXT_OPTIONAL_USE:+ )}"
TOOLDEPS="sys-devel/m4 sys-devel/libtool"

RDEPEND="${PHPDEPEND}"

case ${EAPI:-0} in
	6) DEPEND="${TOOLDEPS} ${PHPDEPEND}" ;;
	7) DEPEND="${PHPDEPEND}" ; BDEPEND="${TOOLDEPS} ${PHPDEPEND}" ;;
esac

unset PHPDEPEND TOOLDEPS

# @ECLASS-VARIABLE: PHP_EXT_SKIP_PHPIZE
# @DEFAULT_UNSET
# @DESCRIPTION:
# By default, we run "phpize" in php-ext-source-r3_src_prepare(). Set
# PHP_EXT_SKIP_PHPIZE="yes" in your ebuild if you do not want to run
# phpize (and the autoreconf that becomes necessary afterwards).

# @ECLASS-VARIABLE: PHP_EXT_SKIP_PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# By default, we run default_src_prepare to PHP_EXT_S.
# Set PHP_EXT_SKIP_PATCHES="yes" in your ebuild if you
# want to apply patches yourself.

# @FUNCTION: php-ext-source-r3_src_prepare
# @DESCRIPTION:
# Runs the default src_prepare() for PATCHES/eapply_user() support (optional),
# and for each PHP slot, makes a copy of sources, initializes the environment,
# and calls php-ext-source-r3_phpize().
php-ext-source-r3_src_prepare() {
	local slot orig_s="${PHP_EXT_S}"
	if [[ "${PHP_EXT_SKIP_PATCHES}" != 'yes' ]] ; then
		pushd "${orig_s}" > /dev/null || die
		default
		popd > /dev/null || die
	fi
	for slot in $(php_get_slots); do
		cp --recursive --preserve "${orig_s}" "${WORKDIR}/${slot}" || \
			die "failed to copy sources from ${orig_s} to ${WORKDIR}/${slot}"
		php_init_slot_env "${slot}"
		php-ext-source-r3_phpize
	done
}

# @FUNCTION: php-ext-source-r3_phpize
# @DESCRIPTION:
# Subject to PHP_EXT_SKIP_PHPIZE, this function runs phpize and
# autoreconf in a manner that avoids warnings.
php-ext-source-r3_phpize() {
	if [[ "${PHP_EXT_SKIP_PHPIZE}" != 'yes' ]] ; then
		# Create configure out of config.m4. We use autotools_run_tool
		# to avoid some warnings about WANT_AUTOCONF and
		# WANT_AUTOMAKE (see bugs #329071 and #549268).
		autotools_run_tool "${PHPIZE}"

		# PHP >=7.4 no longer works with eautoreconf
		if ver_test $PHP_CURRENTSLOT -ge 7.4 ; then
			rm -fr aclocal.m4 autom4te.cache config.cache \
				configure main/php_config.h.in || die
			eautoconf --force
			eautoheader
		else
			# Force libtoolize to run and regenerate autotools files (bug
			# #220519).
			rm aclocal.m4 || die "failed to remove aclocal.m4"
			eautoreconf
		fi
	fi
}


# @ECLASS-VARIABLE: PHP_EXT_ECONF_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this in the ebuild to pass additional configure options to
# econf. Formerly called my_conf. Either a string or an array of
# --flag=value parameters is supported.

# @FUNCTION: php-ext-source-r3_src_configure
# @DESCRIPTION:
# Takes care of standard configure for PHP extensions (modules).
php-ext-source-r3_src_configure() {
	# net-snmp creates these, bug #385403.
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	# Support either a string or an array for PHP_EXT_ECONF_ARGS.
	local econf_args
	if [[ -n "${PHP_EXT_ECONF_ARGS}" && $(declare -p PHP_EXT_ECONF_ARGS) == "declare -a"* ]]; then
		econf_args=( "${PHP_EXT_ECONF_ARGS[@]}" )
	else
		econf_args=( ${PHP_EXT_ECONF_ARGS} )
	fi

	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		econf --with-php-config="${PHPCONFIG}" "${econf_args[@]}"
	done
}

# @FUNCTION: php-ext-source-r3_src_compile
# @DESCRIPTION:
# Compile a standard standalone PHP extension.
php-ext-source-r3_src_compile() {
	# net-snmp creates these, bug #324739.
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	# shm extension creates a semaphore file, bug #173574.
	addpredict /session_mm_cli0.sem
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		emake
	done
}

# @FUNCTION: php-ext-source-r3_src_install
# @DESCRIPTION:
# Install a standard standalone PHP extension. Uses einstalldocs()
# to support the DOCS variable/array.
php-ext-source-r3_src_install() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"

		# Strip $EPREFIX from $EXT_DIR before calling doexe (which
		# handles EPREFIX itself). Shared libs are +x by convention,
		# although nothing seems to depend on that.
		exeinto "${EXT_DIR#$EPREFIX}"
		doexe "modules/${PHP_EXT_NAME}.so"

		INSTALL_ROOT="${D}" emake install-headers
	done
	einstalldocs
	php-ext-source-r3_createinifiles
}

# @FUNCTION: php-ext-source-r3_src_test
# @DESCRIPTION:
# Run tests delivered with the standalone PHP extension. Phpize will have generated
# a run-tests.php file to be executed by `make test`. We only need to
# force the test suite to run in non-interactive mode.
php-ext-source-r3_src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		NO_INTERACTION="yes" emake test
	done
}

# @FUNCTION: php_get_slots
# @DESCRIPTION:
# Get a list of PHP slots contained in both the ebuild's USE_PHP and the
# user's PHP_TARGETS.
php_get_slots() {
	local s=""
	local slot
	for slot in ${USE_PHP}; do
		use php_targets_${slot} && s+=" ${slot/-/.}"
	done
	echo $s
}

# @FUNCTION: php_init_slot_env
# @USAGE: <slot>
# @DESCRIPTION:
# Takes a slot name, and initializes some global variables to values
# corresponding to that slot. For example, it sets the path to the "php"
# and "phpize" binaries, which will differ for each slot. This function
# is intended to be called while looping through a list of slots
# obtained from php_get_slots().
#
# Calling this function will change the working directory to the
# temporary build directory for the given slot.
php_init_slot_env() {
	local libdir=$(get_libdir)
	local slot="${1}"

	PHPPREFIX="${EPREFIX}/usr/${libdir}/${slot}"
	PHPIZE="${PHPPREFIX}/bin/phpize"
	PHPCONFIG="${PHPPREFIX}/bin/php-config"
	PHPCLI="${PHPPREFIX}/bin/php"
	PHPCGI="${PHPPREFIX}/bin/php-cgi"
	PHP_PKG="$(best_version =dev-lang/php-${1:3}*)"

	EXT_DIR="$(${PHPCONFIG} --extension-dir 2>/dev/null)"
	PHP_CURRENTSLOT=${1:3}

	PHP_EXT_S="${WORKDIR}/${slot}"
	cd "${PHP_EXT_S}" || die "failed to change directory to ${PHP_EXT_S}"
}

# @FUNCTION: php_slot_ini_files
# @USAGE: <slot>
# @INTERNAL
# @DESCRIPTION:
# Output a list of relative paths to INI files for the given
# slot. Usually there will be one INI file per SAPI.
php_slot_ini_files() {
	local slot_ini_files=""
	local x
	for x in ${PHP_EXT_SAPIS} ; do
		if [[ -f "${EPREFIX}/etc/php/${x}-${1}/php.ini" ]] ; then
			slot_ini_files+=" etc/php/${x}-${1}/ext/${PHP_INI_NAME}.ini"
		fi
	done

	echo "${slot_ini_files}"
}

# @FUNCTION: php-ext-source-r3_createinifiles
# @DESCRIPTION:
# Builds INI files for every enabled slot and SAPI.
php-ext-source-r3_createinifiles() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"

		local file
		for file in $(php_slot_ini_files "${slot}") ; do
			if [[ "${PHP_EXT_INI}" = "yes" ]] ; then
				# Add the needed lines to the <ext>.ini files
				php-ext-source-r3_addextension "${PHP_EXT_NAME}.so" "${file}"
			fi

			if [[ -n "${PHP_EXT_INIFILE}" ]] ; then
				cat "${FILESDIR}/${PHP_EXT_INIFILE}" >> "${ED}/${file}" \
					|| die "failed to append to ${ED}/${file}"

				einfo "Added contents of ${FILESDIR}/${PHP_EXT_INIFILE}" \
					  "to ${file}"
			fi
			inidir="${file/${PHP_INI_NAME}.ini/}"
			inidir="${inidir/ext/ext-active}"
			dodir "/${inidir}"
			dosym "../ext/${PHP_INI_NAME}.ini" "/${file/ext/ext-active}"
		done
	done

	# A location where PHP code for this extension can be stored,
	# independent of the PHP or extension versions. This will be part of
	# PHP's include_path, configured in php.ini. For example, pecl-apcu
	# installs an "apc.php" file which you are supposed to load with
	#
	#   require('apcu/apc.php');
	#
	PHP_EXT_SHARED_DIR="${EPREFIX}/usr/share/php/${PHP_EXT_NAME}"
}

# @FUNCTION: php-ext-source-r3_addextension
# @USAGE: <extension-path> <ini-file>
# @INTERNAL
# @DESCRIPTION:
# Add a line to an INI file that will enable the given extension. The
# first parameter is the path to the extension (.so) file, and the
# second parameter is the name of the INI file in which it should be
# loaded. This function determines the setting name (either
# "extension=..." or "zend_extension=...") and then calls
# php-ext-source-r3_addtoinifile to do the actual work.
php-ext-source-r3_addextension() {
	local ext_type="extension"
	local ext_file="${1}"

	if [[ "${PHP_EXT_ZENDEXT}" = "yes" ]] ; then
		ext_type="zend_extension"
		ext_file="${EXT_DIR}/${1}" # Zend extensions need the path...
	fi

	php-ext-source-r3_addtoinifile "${2}" "${ext_type}" "${ext_file}"
}

# @FUNCTION: php-ext-source-r3_addtoinifile
# @USAGE: <relative-ini-path> <setting-or-section-name> [setting-value]
# @INTERNAL
# @DESCRIPTION:
# Add a setting=value to one INI file. The first argument is the
# relative path to the INI file. The second argument is the setting
# name, and the third argument is its value.
#
# You can also pass "[Section]" as the second parameter, to create a new
# section in the INI file. In that case, the third parameter (which
# would otherwise be the value of the setting) is ignored.
php-ext-source-r3_addtoinifile() {
	local inifile="${WORKDIR}/${1}"
	local inidir="${inifile%/*}"

	mkdir -p "${inidir}" || die "failed to create INI directory ${inidir}"

	# Are we adding the name of a section? Assume not by default.
	local my_added="${2}=${3}"
	if [[ ${2:0:1} == "[" ]] ; then
		# Ok, it's a section name.
		my_added="${2}"
	fi
	echo "${my_added}" >> "${inifile}" || die "failed to append to ${inifile}"
	einfo "Added '${my_added}' to /${1}"

	insinto "/${1%/*}"
	doins "${inifile}"
}

# @FUNCTION: php-ext-source-r3_addtoinifiles
# @USAGE: <setting-or-section-name> [setting-value] [message]
# @DESCRIPTION:
# Add settings to every php.ini file installed by this extension.
# You can also add new [Section]s -- see the example below.
#
# @CODE
# Add some settings for the extension:
#
# php-ext-source-r3_addtoinifiles "zend_optimizer.optimization_level" "15"
# php-ext-source-r3_addtoinifiles "zend_optimizer.enable_loader" "0"
# php-ext-source-r3_addtoinifiles "zend_optimizer.disable_licensing" "0"
#
# Adding values to a section in php.ini file installed by the extension:
#
# php-ext-source-r3_addtoinifiles "[Debugger]"
# php-ext-source-r3_addtoinifiles "debugger.enabled" "on"
# php-ext-source-r3_addtoinifiles "debugger.profiler_enabled" "on"
# @CODE
php-ext-source-r3_addtoinifiles() {
	local slot
	for slot in $(php_get_slots); do
		for file in $(php_slot_ini_files "${slot}") ; do
			php-ext-source-r3_addtoinifile "${file}" "${1}" "${2}"
		done
	done
}
