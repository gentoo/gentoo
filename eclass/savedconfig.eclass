# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: savedconfig.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: common API for saving/restoring complex configuration files
# @DESCRIPTION:
# It is not uncommon to come across a package which has a very fine
# grained level of configuration options that go way beyond what
# USE flags can properly describe.  For this purpose, a common API
# of saving and restoring the configuration files was developed
# so users can modify these config files and the ebuild will take it
# into account as needed.
#
# Typically you can create your own configuration files quickly by
# doing:
#
# 1. Build the package with FEATURES=noclean USE=savedconfig.
#
# 2. Go into the build dir and edit the relevant configuration system
# (e.g. `make menuconfig` or `nano config-header.h`).  You can look
# at the files in /etc/portage/savedconfig/ to see what files get
# loaded/restored.
#
# 3. Copy the modified configuration files out of the workdir and to
# the paths in /etc/portage/savedconfig/.
#
# 4. Emerge the package with just USE=savedconfig to get the custom
# build.

inherit portability

IUSE="savedconfig"

case ${EAPI} in
	6|7|8) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

# @FUNCTION: save_config
# @USAGE: <config files to save>
# @DESCRIPTION:
# Use this function to save the package's configuration file into the
# right location.  You may specify any number of configuration files,
# but just make sure you call save_config with all of them at the same
# time in order for things to work properly.
save_config() {
	if [[ ${EBUILD_PHASE} != "install" ]]; then
		die "Bad package!  save_config only for use in src_install functions!"
	fi
	[[ $# -eq 0 ]] && die "Usage: save_config <files>"

	local configfile="/etc/portage/savedconfig/${CATEGORY}/${PF}"

	if [[ $# -eq 1 && -f $1 ]] ; then
		# Just one file, so have the ${configfile} be that config file
		dodir "${configfile%/*}"
		cp "$@" "${ED%/}/${configfile}" || die "failed to save $*"
	else
		# A dir, or multiple files, so have the ${configfile} be a dir
		# with all the saved stuff below it
		dodir "${configfile}"
		treecopy "$@" "${ED%/}/${configfile}" || die "failed to save $*"
	fi

	elog "Your configuration for ${CATEGORY}/${PF} has been saved in "
	elog "\"${configfile}\" for your editing pleasure."
	elog "You can edit these files by hand and remerge this package with"
	elog "USE=savedconfig to customise the configuration."
	elog "You can rename this file/directory to one of the following for"
	elog "its configuration to apply to multiple versions:"
	elog '${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/'
	elog '[${CTARGET}|${CHOST}|""]/${CATEGORY}/[${PF}|${P}|${PN}]'
}

# @FUNCTION: restore_config
# @USAGE: <config files to restore>
# @DESCRIPTION:
# Restores the package's configuration file probably with user edits.
# You can restore a single file or a whole bunch, just make sure you call
# restore_config with all of the files to restore at the same time.
#
# Config files can be laid out as:
# @CODE
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CTARGET}/${CATEGORY}/${PF}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CHOST}/${CATEGORY}/${PF}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CATEGORY}/${PF}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CTARGET}/${CATEGORY}/${P}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CHOST}/${CATEGORY}/${P}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CATEGORY}/${P}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CTARGET}/${CATEGORY}/${PN}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CHOST}/${CATEGORY}/${PN}
# ${PORTAGE_CONFIGROOT}/etc/portage/savedconfig/${CATEGORY}/${PN}
# @CODE
restore_config() {
	case ${EBUILD_PHASE} in
		unpack|compile|configure|prepare) ;;
		*) die "Bad package!  restore_config only for use in src_{unpack,compile,configure,prepare} functions!" ;;
	esac

	use savedconfig || return

	local found check checked configfile
	local base=${PORTAGE_CONFIGROOT%/}/etc/portage/savedconfig
	for check in {${CATEGORY}/${PF},${CATEGORY}/${P},${CATEGORY}/${PN}}; do
		configfile=${base}/${CTARGET:+"${CTARGET}/"}${check}
		[[ -r ${configfile} ]] || configfile=${base}/${CHOST:+"${CHOST}/"}${check}
		[[ -r ${configfile} ]] || configfile=${base}/${check}
		[[ "${checked}" == *"${configfile} "* ]] && continue
		einfo "Checking existence of \"${configfile}\" ..."
		if [[ -r "${configfile}" ]] ; then
			einfo "Found \"${configfile}\""
			found=${configfile}
			break
		fi

		checked+="${configfile} "
	done

	if [[ -f ${found} ]]; then
		elog "Building using saved configfile \"${found}\""
		if [ $# -gt 0 ]; then
			cp -pPR	"${found}" "$1" || die "Failed to restore ${found} to $1"
		else
			die "need to know the restoration filename"
		fi
	elif [[ -d ${found} ]]; then
		elog "Building using saved config directory \"${found}\""
		local dest=${PWD}
		pushd "${found}" > /dev/null
		treecopy . "${dest}" || die "Failed to restore ${found} to $1"
		popd > /dev/null
	else
		ewarn "No saved config to restore - please remove USE=savedconfig or"
		ewarn "provide a configuration file in ${PORTAGE_CONFIGROOT%/}/etc/portage/savedconfig/${CATEGORY}/${PN}"
		ewarn "and ensure the build process has permission to access it."
		ewarn "Your config file(s) will not be used this time."
	fi
}

savedconfig_pkg_postinst() {
	# If the user has USE=savedconfig, then chances are they
	# are modifying these files, so keep them around.  #396169
	# This might lead to cruft build up, but the alternatives
	# are worse :/.

	if use savedconfig ; then
		find "${EROOT%/}/etc/portage/savedconfig/${CATEGORY}/${PF}" \
			-exec touch {} + 2>/dev/null
	fi
}

EXPORT_FUNCTIONS pkg_postinst
