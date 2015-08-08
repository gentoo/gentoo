# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: php-ext-source-r2.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @AUTHOR:
# Author: Tal Peer <coredumb@gentoo.org>
# Author: Stuart Herbert <stuart@gentoo.org>
# Author: Luca Longinotti <chtekk@gentoo.org>
# Author: Jakub Moc <jakub@gentoo.org> (documentation)
# Author: Ole Markus With <olemarkus@gentoo.org>
# @BLURB: A unified interface for compiling and installing standalone PHP extensions.
# @DESCRIPTION:
# This eclass provides a unified interface for compiling and installing standalone
# PHP extensions (modules).

inherit flag-o-matic autotools multilib eutils

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install

DEPEND=">=sys-devel/m4-1.4.3
		>=sys-devel/libtool-1.5.18"
RDEPEND=""

# Because of USE deps, we require at least EAPI 2
case ${EAPI} in
	4|5) ;;
	*)
		die "php-ext-source-r2 is not compatible with EAPI=${EAPI}"
esac

# @ECLASS-VARIABLE: PHP_EXT_NAME
# @REQUIRED
# @DESCRIPTION:
# The extension name. This must be set, otherwise the eclass dies.
# Only automagically set by php-ext-pecl-r2.eclass, so unless your ebuild
# inherits that eclass, you must set this manually before inherit.
[[ -z "${PHP_EXT_NAME}" ]] && die "No module name specified for the php-ext-source-r2 eclass"

# @ECLASS-VARIABLE: PHP_EXT_INI
# @DESCRIPTION:
# Controls whether or not to add a line to php.ini for the extension.
# Defaults to "yes" and should not be changed in most cases.
[[ -z "${PHP_EXT_INI}" ]] && PHP_EXT_INI="yes"

# @ECLASS-VARIABLE: PHP_EXT_ZENDEXT
# @DESCRIPTION:
# Controls whether the extension is a ZendEngine extension or not.
# Defaults to "no" and if you don't know what is it, you don't need it.
[[ -z "${PHP_EXT_ZENDEXT}" ]] && PHP_EXT_ZENDEXT="no"

# @ECLASS-VARIABLE: USE_PHP
# @REQUIRED
# @DESCRIPTION:
# Lists the PHP slots compatibile the extension is compatibile with
# Example:
# @CODE
# USE_PHP="php5-5 php5-6"
# @CODE
[[ -z "${USE_PHP}" ]] && die "USE_PHP is not set for the php-ext-source-r2 eclass"

# @ECLASS-VARIABLE: PHP_EXT_OPTIONAL_USE
# @DESCRIPTION:
# If set, this is the USE flag that the PHP dependencies are behind
# Most commonly set as PHP_EXT_OPTIONAL_USE=php to get the dependencies behind
# USE=php.

# @ECLASS-VARIABLE: PHP_EXT_S
# @DESCRIPTION:
# The relative location of the temporary build directory for the PHP extension within
# the source package. This is useful for packages that bundle the PHP extension.
# Defaults to ${S}
[[ -z "${PHP_EXT_S}" ]] && PHP_EXT_S="${S}"

#Make sure at least one target is installed.
REQUIRED_USE="${PHP_EXT_OPTIONAL_USE}${PHP_EXT_OPTIONAL_USE:+? ( }|| ( "
for target in ${USE_PHP}; do
	IUSE="${IUSE} php_targets_${target}"
	target=${target/+}
	REQUIRED_USE+="php_targets_${target} "
	slot=${target/php}
	slot=${slot/-/.}
	PHPDEPEND="${PHPDEPEND}
	php_targets_${target}? ( dev-lang/php:${slot} )"
done
REQUIRED_USE+=") ${PHP_EXT_OPTIONAL_USE:+ )}"

RDEPEND="${RDEPEND}
	${PHP_EXT_OPTIONAL_USE}${PHP_EXT_OPTIONAL_USE:+? ( }
	${PHPDEPEND}
	${PHP_EXT_OPTIONAL_USE:+ )}"

DEPEND="${DEPEND}
	${PHP_EXT_OPTIONAL_USE}${PHP_EXT_OPTIONAL_USE:+? ( }
	${PHPDEPEND}
	${PHP_EXT_OPTIONAL_USE:+ )}
"

# @FUNCTION: php-ext-source-r2_src_unpack
# @DESCRIPTION:
# runs standard src_unpack + _phpize

# @ECLASS-VARIABLE: PHP_EXT_SKIP_PHPIZE
# @DESCRIPTION:
# phpize will be run by default for all ebuilds that use
# php-ext-source-r2_src_unpack
# Set PHP_EXT_SKIP_PHPIZE="yes" in your ebuild if you do not want to run phpize.

php-ext-source-r2_src_unpack() {
	unpack ${A}
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		cp -r "${orig_s}" "${WORKDIR}/${slot}" || die "Failed to copy source ${orig_s} to PHP target directory"
	done
}

php-ext-source-r2_src_prepare() {
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		php-ext-source-r2_phpize
	done
}

# @FUNCTION: php-ext-source-r2_phpize
# @DESCRIPTION:
# Runs phpize and autotools in addition to the standard src_unpack
php-ext-source-r2_phpize() {
	if [[ "${PHP_EXT_SKIP_PHPIZE}" != 'yes' ]] ; then
		# Create configure out of config.m4
		# I wish I could run this to solve #329071, but I cannot
		#autotools_run_tool ${PHPIZE}
		${PHPIZE}
		# force run of libtoolize and regeneration of related autotools
		# files (bug 220519)
		rm aclocal.m4
		eautoreconf
	fi
}

# @FUNCTION: php-ext-source-r2_src_configure
# @DESCRIPTION:
# Takes care of standard configure for PHP extensions (modules).

# @ECLASS-VARIABLE: my_conf
# @DESCRIPTION:
# Set this in the ebuild to pass configure options to econf.

php-ext-source-r2_src_configure() {
	# net-snmp creates this file #385403
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		# Set the correct config options
		econf --with-php-config=${PHPCONFIG} ${my_conf}  || die "Unable to configure code to compile"
	done
}

# @FUNCTION: php-ext-source-r2_src_compile
# @DESCRIPTION:
# Takes care of standard compile for PHP extensions (modules).
php-ext-source-r2_src_compile() {
	# net-snmp creates this file #324739
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/mib_indexes

	# shm extension createss a semaphore file #173574
	addpredict /session_mm_cli0.sem
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		emake || die "Unable to make code"

	done
}

# @FUNCTION: php-ext-source-r2_src_install
# @DESCRIPTION:
# Takes care of standard install for PHP extensions (modules).

# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Set in ebuild if you wish to install additional, package-specific documentation.
php-ext-source-r2_src_install() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}

		# Let's put the default module away
		insinto "${EXT_DIR}"
		newins "modules/${PHP_EXT_NAME}.so" "${PHP_EXT_NAME}.so" || die "Unable to install extension"

		local doc
		for doc in ${DOCS} ; do
			[[ -s ${doc} ]] && dodoc ${doc}
		done

		INSTALL_ROOT="${D}" emake install-headers
	done
	php-ext-source-r2_createinifiles
}


php_get_slots() {
	local s slot
	for slot in ${USE_PHP}; do
		use php_targets_${slot} && s+=" ${slot/-/.}"
	done
	echo $s
}

php_init_slot_env() {
	libdir=$(get_libdir)

	PHPIZE="/usr/${libdir}/${1}/bin/phpize"
	PHPCONFIG="/usr/${libdir}/${1}/bin/php-config"
	PHPCLI="/usr/${libdir}/${1}/bin/php"
	PHPCGI="/usr/${libdir}/${1}/bin/php-cgi"
	PHP_PKG="$(best_version =dev-lang/php-${1:3}*)"
	PHPPREFIX="/usr/${libdir}/${slot}"
	EXT_DIR="$(${PHPCONFIG} --extension-dir 2>/dev/null)"
	PHP_CURRENTSLOT=${1:3}

	PHP_EXT_S="${WORKDIR}/${1}"
	cd "${PHP_EXT_S}"
}

php-ext-source-r2_buildinilist() {
	# Work out the list of <ext>.ini files to edit/add to
	if [[ -z "${PHPSAPILIST}" ]] ; then
		PHPSAPILIST="apache2 cli cgi fpm embed"
	fi

	PHPINIFILELIST=""
	local x
	for x in ${PHPSAPILIST} ; do
		if [[ -f "/etc/php/${x}-${1}/php.ini" ]] ; then
			PHPINIFILELIST="${PHPINIFILELIST} etc/php/${x}-${1}/ext/${PHP_EXT_NAME}.ini"
		fi
	done
	PHPFULLINIFILELIST="${PHPFULLINIFILELIST} ${PHPINIFILELIST}"
}

# @FUNCTION: php-ext-source-r2_createinifiles
# @DESCRIPTION:
# Builds ini files for every enabled slot and SAPI
php-ext-source-r2_createinifiles() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		# Pull in the PHP settings

		# Build the list of <ext>.ini files to edit/add to
		php-ext-source-r2_buildinilist ${slot}


		# Add the needed lines to the <ext>.ini files
		local file
		if [[ "${PHP_EXT_INI}" = "yes" ]] ; then
			for file in ${PHPINIFILELIST}; do
				php-ext-source-r2_addextension "${PHP_EXT_NAME}.so" "${file}"
			done
		fi

		# Symlink the <ext>.ini files from ext/ to ext-active/
		local inifile
		for inifile in ${PHPINIFILELIST} ; do
			if [[ -n "${PHP_EXT_INIFILE}" ]]; then
				cat "${FILESDIR}/${PHP_EXT_INIFILE}" >> "${ED}/${inifile}"
				einfo "Added content of ${FILESDIR}/${PHP_EXT_INIFILE} to ${inifile}"
			fi
			inidir="${inifile/${PHP_EXT_NAME}.ini/}"
			inidir="${inidir/ext/ext-active}"
			dodir "/${inidir}"
			dosym "/${inifile}" "/${inifile/ext/ext-active}"
		done

		# Add support for installing PHP files into a version dependant directory
		PHP_EXT_SHARED_DIR="/usr/share/php/${PHP_EXT_NAME}"
	done
}

php-ext-source-r2_addextension() {
	if [[ "${PHP_EXT_ZENDEXT}" = "yes" ]] ; then
		# We need the full path for ZendEngine extensions
		# and we need to check for debugging enabled!
		if has_version "dev-lang/php:${PHP_CURRENTSLOT}[threads]" ; then
			if has_version "dev-lang/php:${PHP_CURRENTSLOT}[debug]" ; then
				ext_type="zend_extension_debug_ts"
			else
				ext_type="zend_extension_ts"
			fi
			ext_file="${EXT_DIR}/${1}"
		else
			if has_version "dev-lang/php:${PHP_CURRENTSLOT}[debug]"; then
				ext_type="zend_extension_debug"
			else
				ext_type="zend_extension"
			fi
			ext_file="${EXT_DIR}/${1}"
		fi

		# php-5.3 unifies zend_extension loading and just requires the
		# zend_extension keyword with no suffix
		# TODO: drop previous code and this check once <php-5.3 support is
		# discontinued
		if has_version '>=dev-lang/php-5.3' ; then
			ext_type="zend_extension"
		fi
	else
		# We don't need the full path for normal extensions!
		ext_type="extension"
		ext_file="${1}"
	fi

	php-ext-source-r2_addtoinifile "${ext_type}" "${ext_file}" "${2}" "Extension added"
}

# $1 - Setting name
# $2 - Setting value
# $3 - File to add to
# $4 - Sanitized text to output
php-ext-source-r2_addtoinifile() {
	local inifile="${WORKDIR}/${3}"
	if [[ ! -d $(dirname ${inifile}) ]] ; then
		mkdir -p $(dirname ${inifile})
	fi

	# Are we adding the name of a section?
	if [[ ${1:0:1} == "[" ]] ; then
		echo "${1}" >> "${inifile}"
		my_added="${1}"
	else
		echo "${1}=${2}" >> "${inifile}"
		my_added="${1}=${2}"
	fi

	if [[ -z "${4}" ]] ; then
		einfo "Added '${my_added}' to /${3}"
	else
		einfo "${4} to /${3}"
	fi

	insinto /$(dirname ${3})
	doins "${inifile}"
}

# @FUNCTION: php-ext-source-r2_addtoinifiles
# @USAGE: <setting name> <setting value> [message to output]; or just [section name]
# @DESCRIPTION:
# Add value settings to php.ini file installed by the extension (module).
# You can also add a [section], see examples below.
#
# @CODE
# Add some settings for the extension:
#
# php-ext-source-r2_addtoinifiles "zend_optimizer.optimization_level" "15"
# php-ext-source-r2_addtoinifiles "zend_optimizer.enable_loader" "0"
# php-ext-source-r2_addtoinifiles "zend_optimizer.disable_licensing" "0"
#
# Adding values to a section in php.ini file installed by the extension:
#
# php-ext-source-r2_addtoinifiles "[Debugger]"
# php-ext-source-r2_addtoinifiles "debugger.enabled" "on"
# php-ext-source-r2_addtoinifiles "debugger.profiler_enabled" "on"
# @CODE
php-ext-source-r2_addtoinifiles() {
	local x
	for x in ${PHPFULLINIFILELIST} ; do
		php-ext-source-r2_addtoinifile "${1}" "${2}" "${x}" "${3}"
	done
}
