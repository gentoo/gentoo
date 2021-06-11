# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: alternatives.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Alastair Tse <liquidx@gentoo.org> (03 Oct 2003)
# @BLURB: Creates symlink to the latest version of multiple slotted packages.
# @DESCRIPTION:
# When a package is SLOT'ed, very often we need to have a symlink to the
# latest version. However, depending on the order the user has merged them,
# more often than not, the symlink maybe clobbered by the older versions.
#
# This eclass provides a convenience function that needs to be given a
# list of alternatives (descending order of recent-ness) and the symlink.
# It will choose the latest version it can find installed and create
# the desired symlink.
#
# There are two ways to use this eclass. First is by declaring two variables
# $SOURCE and $ALTERNATIVES where $SOURCE is the symlink to be created and
# $ALTERNATIVES is a list of alternatives. Second way is the use the function
# alternatives_makesym() like the example below.
# @EXAMPLE:
# pkg_postinst() {
#     alternatives_makesym "/usr/bin/python" "/usr/bin/python2.3" "/usr/bin/python2.2"
# }
#
# The above example will create a symlink at /usr/bin/python to either
# /usr/bin/python2.3 or /usr/bin/python2.2. It will choose python2.3 over
# python2.2 if both exist.
#
# Alternatively, you can use this function:
#
# pkg_postinst() {
#    alternatives_auto_makesym "/usr/bin/python" "/usr/bin/python[0-9].[0-9]"
# }
#
# This will use bash pathname expansion to fill a list of alternatives it can
# link to. It is probably more robust against version upgrades. You should
# consider using this unless you are want to do something special.

# @ECLASS-VARIABLE: SOURCE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The symlink to be created

# @ECLASS-VARIABLE: ALTERNATIVES
# @DEFAULT_UNSET
# @DESCRIPTION:
# The list of alternatives

# @FUNCTION: alternatives_auto_makesym
# @DESCRIPTION:
# automatic deduction based on a symlink and a regex mask
alternatives_auto_makesym() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EROOT="${ROOT}"
	local SYMLINK REGEX ALT myregex
	SYMLINK=$1
	REGEX=$2
	if [ "${REGEX:0:1}" != "/" ]
	then
		#not an absolute path:
		#inherit the root directory of our main link path for our regex search
		myregex="${SYMLINK%/*}/${REGEX}"
	else
		myregex=${REGEX}
	fi

	# sort a space delimited string by converting it to a multiline list
	# and then run sort -r over it.
	# make sure we use ${EROOT} because otherwise stage-building will break
	ALT="$(for i in $(echo ${EROOT}${myregex}); do echo ${i#${EROOT}}; done | sort -r)"
	alternatives_makesym ${SYMLINK} ${ALT}
}

alternatives_makesym() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	local ALTERNATIVES=""
	local SYMLINK=""
	local alt pref

	# usage: alternatives_makesym <resulting symlink> [alternative targets..]
	# make sure it is in the prefix, allow it already to be in the prefix
	SYMLINK=${EPREFIX}/${1#${EPREFIX}}
	# this trick removes the trailing / from ${ROOT}
	pref=${ROOT%/}
	shift
	ALTERNATIVES=$@

	# step through given alternatives from first to last
	# and if one exists, link it and finish.

	for alt in ${ALTERNATIVES}; do
		alt=${EPREFIX}/${alt#${EPREFIX}}
		if [ -f "${pref}${alt}" ]; then
			#are files in same directory?
			if [ "${alt%/*}" = "${SYMLINK%/*}" ]
			then
				#yes; strip leading dirname from alt to create relative symlink
				einfo "Linking ${alt} to ${pref}${SYMLINK} (relative)"
				ln -sf ${alt##*/} ${pref}${SYMLINK}
			else
				#no; keep absolute path
				einfo "Linking ${alt} to ${pref}${SYMLINK} (absolute)"
				ln -sf ${pref}${alt} ${pref}${SYMLINK}
			fi
			break
		fi
	done

	# report any errors
	if [ ! -L ${pref}${SYMLINK} ]; then
		ewarn "Unable to establish ${pref}${SYMLINK} symlink"
	else
		# we need to check for either the target being in relative path form
		# or absolute path form
		if [ ! -f "`dirname ${pref}${SYMLINK}`/`readlink ${pref}${SYMLINK}`" -a \
			 ! -f "`readlink ${pref}${SYMLINK}`" ]; then
			ewarn "Removing dead symlink ${pref}${SYMLINK}"
			rm -f ${pref}${SYMLINK}
		fi
	fi
}

# @FUNCTION: alernatives-pkg_postinst
# @DESCRIPTION:
# The alternatives pkg_postinst, this function will be exported
alternatives_pkg_postinst() {
	if [ -n "${ALTERNATIVES}" -a -n "${SOURCE}" ]; then
		alternatives_makesym ${SOURCE} ${ALTERNATIVES}
	fi
}

# @FUNCTION: alternatives_pkg_postrm
# @DESCRIPTION:
# The alternatives pkg_postrm, this function will be exported
alternatives_pkg_postrm() {
	if [ -n "${ALTERNATIVES}" -a -n "${SOURCE}" ]; then
		alternatives_makesym ${SOURCE} ${ALTERNATIVES}
	fi
}

EXPORT_FUNCTIONS pkg_postinst pkg_postrm
