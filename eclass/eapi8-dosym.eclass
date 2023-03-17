# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eapi8-dosym.eclass
# @MAINTAINER:
# PMS team <pms@gentoo.org>
# @AUTHOR:
# Ulrich Müller <ulm@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Testing implementation of EAPI 8 dosym -r option
# @DESCRIPTION:
# A stand-alone implementation of the dosym command aimed for EAPI 8.
# Intended to be used for wider testing of the proposed option and to
# allow ebuilds to switch to the new model early, with minimal change
# needed for actual EAPI 8.
#
# https://bugs.gentoo.org/708360

case ${EAPI} in
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: _dosym8_canonicalize
# @USAGE: <path>
# @INTERNAL
# @DESCRIPTION:
# Transparent bash-only replacement for GNU "realpath -m -s".
# Resolve references to "/./", "/../" and remove extra "/" characters
# from <path>, without touching any actual file.
_dosym8_canonicalize() {
	local path slash i prev out IFS=/

	path=( $1 )
	[[ $1 == /* ]] && slash=/

	while true; do
		# Find first instance of non-".." path component followed by "..",
		# or as a special case, "/.." at the beginning of the path.
		# Also drop empty and "." path components as we go along.
		prev=
		for i in ${!path[@]}; do
			if [[ -z ${path[i]} || ${path[i]} == . ]]; then
				unset "path[i]"
			elif [[ ${path[i]} != .. ]]; then
				prev=${i}
			elif [[ ${prev} || ${slash} ]]; then
				# Found, remove path components and reiterate
				[[ ${prev} ]] && unset "path[prev]"
				unset "path[i]"
				continue 2
			fi
		done
		# No (further) instance found, so we're done
		break
	done

	out="${slash}${path[*]}"
	echo "${out:-.}"
}

# @FUNCTION: dosym8
# @USAGE: [-r] <target> <link>
# @DESCRIPTION:
# Create a symbolic link <link>, pointing to <target>.  If the
# directory containing the new link does not exist, create it.
#
# If called with option -r, expand <target> relative to the apparent
# path of the directory containing <link>.  For example, "dosym8 -r
# /bin/foo /usr/bin/foo" will create a link named "../../bin/foo".
dosym8() {
	local option_r

	case $1 in
		-r) option_r=t; shift ;;
	esac

	[[ $# -eq 2 ]] || die "${FUNCNAME}: bad number of arguments"

	local target=$1 link=$2

	if [[ ${option_r} ]]; then
		local linkdir comp

		# Expansion makes sense only for an absolute target path
		[[ ${target} == /* ]] \
			|| die "${FUNCNAME}: -r specified but no absolute target path"

		target=$(_dosym8_canonicalize "${target}")
		linkdir=$(_dosym8_canonicalize "/${link#/}")
		linkdir=${linkdir%/*}	# poor man's dirname(1)
		linkdir=${linkdir:-/}	# always keep the initial "/"

		local ifs_save=${IFS-$' \t\n'} IFS=/
		for comp in ${linkdir}; do
			if [[ ${target%%/*} == "${comp}" ]]; then
				target=${target#"${comp}"}
				target=${target#/}
			else
				target=..${target:+/}${target}
			fi
		done
		IFS=${ifs_save}
		target=${target:-.}
	fi

	dosym "${target}" "${link}"
}
