# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/cdrom.eclass,v 1.6 2014/07/11 08:21:58 ulm Exp $

# @ECLASS: cdrom.eclass
# @MAINTAINER:
# games@gentoo.org
# @BLURB: Functions for CD-ROM handling
# @DESCRIPTION:
# Acquire cd(s) for those lovely cd-based emerges.  Yes, this violates
# the whole 'non-interactive' policy, but damnit I want CD support!
#
# With these cdrom functions we handle all the user interaction and
# standardize everything.  All you have to do is call cdrom_get_cds()
# and when the function returns, you can assume that the cd has been
# found at CDROM_ROOT.

if [[ -z ${_CDROM_ECLASS} ]]; then
_CDROM_ECLASS=1

inherit portability

# @ECLASS-VARIABLE: CDROM_OPTIONAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# By default, the eclass sets PROPERTIES="interactive" on the assumption
# that people will be using these.  If your package optionally supports
# disc based installed, then set this to "yes", and we'll set things
# conditionally based on USE=cdinstall.
if [[ ${CDROM_OPTIONAL} == "yes" ]] ; then
	IUSE="cdinstall"
	PROPERTIES="cdinstall? ( interactive )"
else
	PROPERTIES="interactive"
fi

# @FUNCTION: cdrom_get_cds
# @USAGE: <file on cd1> [file on cd2] [file on cd3] [...]
# @DESCRIPTION:
# The function will attempt to locate a cd based upon a file that is on
# the cd.  The more files you give this function, the more cds the cdrom
# functions will handle.
#
# Normally the cdrom functions will refer to the cds as 'cd #1', 'cd #2',
# etc...  If you want to give the cds better names, then just export
# the appropriate CDROM_NAME variable before calling cdrom_get_cds().
# Use CDROM_NAME for one cd, or CDROM_NAME_# for multiple cds.  You can
# also use the CDROM_NAME_SET bash array.
#
# For those multi cd ebuilds, see the cdrom_load_next_cd() function.
cdrom_get_cds() {
	# first we figure out how many cds we're dealing with by
	# the # of files they gave us
	local cdcnt=0
	local f=
	for f in "$@" ; do
		((++cdcnt))
		export CDROM_CHECK_${cdcnt}="$f"
	done
	export CDROM_TOTAL_CDS=${cdcnt}
	export CDROM_CURRENT_CD=1

	# now we see if the user gave use CD_ROOT ...
	# if they did, let's just believe them that it's correct
	if [[ -n ${CD_ROOT}${CD_ROOT_1} ]] ; then
		local var=
		cdcnt=0
		while [[ ${cdcnt} -lt ${CDROM_TOTAL_CDS} ]] ; do
			((++cdcnt))
			var="CD_ROOT_${cdcnt}"
			[[ -z ${!var} ]] && var="CD_ROOT"
			if [[ -z ${!var} ]] ; then
				eerror "You must either use just the CD_ROOT"
				eerror "or specify ALL the CD_ROOT_X variables."
				eerror "In this case, you will need" \
					"${CDROM_TOTAL_CDS} CD_ROOT_X variables."
				die "could not locate CD_ROOT_${cdcnt}"
			fi
		done
		export CDROM_ROOT=${CD_ROOT_1:-${CD_ROOT}}
		einfo "Found CD #${CDROM_CURRENT_CD} root at ${CDROM_ROOT}"
		export CDROM_SET=-1
		for f in ${CDROM_CHECK_1//:/ } ; do
			((++CDROM_SET))
			[[ -e ${CDROM_ROOT}/${f} ]] && break
		done
		export CDROM_MATCH=${f}
		return
	fi

	# User didn't help us out so lets make sure they know they can
	# simplify the whole process ...
	if [[ ${CDROM_TOTAL_CDS} -eq 1 ]] ; then
		einfo "This ebuild will need the ${CDROM_NAME:-cdrom for ${PN}}"
		echo
		einfo "If you do not have the CD, but have the data files"
		einfo "mounted somewhere on your filesystem, just export"
		einfo "the variable CD_ROOT so that it points to the"
		einfo "directory containing the files."
		echo
		einfo "For example:"
		einfo "export CD_ROOT=/mnt/cdrom"
		echo
	else
		if [[ -n ${CDROM_NAME_SET} ]] ; then
			# Translate the CDROM_NAME_SET array into CDROM_NAME_#
			cdcnt=0
			while [[ ${cdcnt} -lt ${CDROM_TOTAL_CDS} ]] ; do
				((++cdcnt))
				export CDROM_NAME_${cdcnt}="${CDROM_NAME_SET[$((${cdcnt}-1))]}"
			done
		fi

		einfo "This package will need access to ${CDROM_TOTAL_CDS} cds."
		cdcnt=0
		while [[ ${cdcnt} -lt ${CDROM_TOTAL_CDS} ]] ; do
			((++cdcnt))
			var="CDROM_NAME_${cdcnt}"
			[[ ! -z ${!var} ]] && einfo " CD ${cdcnt}: ${!var}"
		done
		echo
		einfo "If you do not have the CDs, but have the data files"
		einfo "mounted somewhere on your filesystem, just export"
		einfo "the following variables so they point to the right place:"
		einfon ""
		cdcnt=0
		while [[ ${cdcnt} -lt ${CDROM_TOTAL_CDS} ]] ; do
			((++cdcnt))
			echo -n " CD_ROOT_${cdcnt}"
		done
		echo
		einfo "Or, if you have all the files in the same place, or"
		einfo "you only have one cdrom, you can export CD_ROOT"
		einfo "and that place will be used as the same data source"
		einfo "for all the CDs."
		echo
		einfo "For example:"
		einfo "export CD_ROOT_1=/mnt/cdrom"
		echo
	fi

	export CDROM_SET=""
	export CDROM_CURRENT_CD=0
	cdrom_load_next_cd
}

# @FUNCTION: cdrom_load_next_cd
# @DESCRIPTION:
# Some packages are so big they come on multiple CDs.  When you're done
# reading files off a CD and want access to the next one, just call this
# function.  Again, all the messy details of user interaction are taken
# care of for you.  Once this returns, just read the variable CDROM_ROOT
# for the location of the mounted CD.  Note that you can only go forward
# in the CD list, so make sure you only call this function when you're
# done using the current CD.
cdrom_load_next_cd() {
	local var
	((++CDROM_CURRENT_CD))

	unset CDROM_ROOT
	var=CD_ROOT_${CDROM_CURRENT_CD}
	[[ -z ${!var} ]] && var="CD_ROOT"
	if [[ -z ${!var} ]] ; then
		var="CDROM_CHECK_${CDROM_CURRENT_CD}"
		_cdrom_locate_file_on_cd ${!var}
	else
		export CDROM_ROOT=${!var}
	fi

	einfo "Found CD #${CDROM_CURRENT_CD} root at ${CDROM_ROOT}"
}

# this is used internally by the cdrom_get_cds() and cdrom_load_next_cd()
# functions.  this should *never* be called from an ebuild.
# all it does is try to locate a give file on a cd ... if the cd isn't
# found, then a message asking for the user to insert the cdrom will be
# displayed and we'll hang out here until:
# (1) the file is found on a mounted cdrom
# (2) the user hits CTRL+C
_cdrom_locate_file_on_cd() {
	local mline=""
	local showedmsg=0 showjolietmsg=0

	while [[ -z ${CDROM_ROOT} ]] ; do
		local i=0
		local -a cdset=(${*//:/ })
		if [[ -n ${CDROM_SET} ]] ; then
			cdset=(${cdset[${CDROM_SET}]})
		fi

		while [[ -n ${cdset[${i}]} ]] ; do
			local dir=$(dirname ${cdset[${i}]})
			local file=$(basename ${cdset[${i}]})

			local point= node= fs= foo=
			while read point node fs foo ; do
				[[ " cd9660 iso9660 udf " != *" ${fs} "* ]] && \
					! [[ ${fs} == "subfs" && ",${opts}," == *",fs=cdfss,"* ]] \
					&& continue
				point=${point//\040/ }
				[[ ! -d ${point}/${dir} ]] && continue
				[[ -z $(find "${point}/${dir}" -maxdepth 1 -iname "${file}") ]] \
					&& continue
				export CDROM_ROOT=${point}
				export CDROM_SET=${i}
				export CDROM_MATCH=${cdset[${i}]}
				return
			done <<< "$(get_mounts)"

			((++i))
		done

		echo
		if [[ ${showedmsg} -eq 0 ]] ; then
			if [[ ${CDROM_TOTAL_CDS} -eq 1 ]] ; then
				if [[ -z ${CDROM_NAME} ]] ; then
					einfo "Please insert+mount the cdrom for ${PN} now !"
				else
					einfo "Please insert+mount the ${CDROM_NAME} cdrom now !"
				fi
			else
				if [[ -z ${CDROM_NAME_1} ]] ; then
					einfo "Please insert+mount cd #${CDROM_CURRENT_CD}" \
						"for ${PN} now !"
				else
					local var="CDROM_NAME_${CDROM_CURRENT_CD}"
					einfo "Please insert+mount the ${!var} cdrom now !"
				fi
			fi
			showedmsg=1
		fi
		einfo "Press return to scan for the cd again"
		einfo "or hit CTRL+C to abort the emerge."
		echo
		if [[ ${showjolietmsg} -eq 0 ]] ; then
			showjolietmsg=1
		else
			ewarn "If you are having trouble with the detection"
			ewarn "of your CD, it is possible that you do not have"
			ewarn "Joliet support enabled in your kernel.  Please"
			ewarn "check that CONFIG_JOLIET is enabled in your kernel."
		fi
		read || die "something is screwed with your system"
	done
}

fi
