# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#

# @ECLASS: mozextension.eclass
# @MAINTAINER:
# Mozilla team <mozilla@gentoo.org>
# @BLURB: Install extensions for use in Mozilla products.

if [[ ! ${_MOZEXTENSION} ]]; then

# @ECLASS-VARIABLE: MOZEXTENSION_TARGET
# @DESCRIPTION:
# This variable allows the installation path for xpi_install
# to be overridden from the default app-global extensions path.
# Default is empty, which installs to predetermined hard-coded
# paths specified in the eclass.
: ${MOZEXTENSION_TARGET:=""}

inherit eutils

DEPEND="app-arch/unzip"

mozversion_extension_location() {
	case ${PN} in
		firefox|firefox-bin|palemoon)
			if [[ $(get_version_component_range 1) -ge 21 ]] ; then
				return 0
			fi
		;;
	esac

	return 1
}

xpi_unpack() {
	local xpi xpiname srcdir

	# Not gonna use ${A} as we are looking for a specific option being passed to function
	# You must specify which xpi to use
	[[ -z "$*" ]] && die "Nothing passed to the $FUNCNAME command. please pass which xpi to unpack"

	for xpi in "$@"; do
		einfo "Unpacking ${xpi} to ${PWD}"
		xpiname=$(basename ${xpi%.*})

		if   [[ "${xpi:0:2}" != "./" ]] && [[ "${xpi:0:1}" != "/" ]] ; then
			srcdir="${DISTDIR}/"
		fi

		[[ -s "${srcdir}${xpi}" ]] ||  die "${xpi} does not exist"

		case "${xpi##*.}" in
			ZIP|zip|jar|xpi)
				mkdir "${WORKDIR}/${xpiname}" && \
									   unzip -qo "${srcdir}${xpi}" -d "${WORKDIR}/${xpiname}" ||  die "failed to unpack ${xpi}"
				;;
			*)
				einfo "unpack ${xpi}: file format not recognized. Ignoring."
				;;
		esac
	done
}


xpi_install() {
	local emid

	# You must tell xpi_install which xpi to use
	[[ ${#} -ne 1 ]] && die "$FUNCNAME takes exactly one argument, please specify an xpi to unpack"

	x="${1}"
	#cd ${x}
	# determine id for extension
	if [[ -f "${x}"/install.rdf ]]; then
		emid="$(sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' "${x}"/install.rdf)"
		[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
	elif [[ -f "${x}"/manifest.json ]]; then
		emid="$( sed -n 's/.*"id": "\(.*\)".*/\1/p' "${x}"/manifest.json )"
		[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
	else
		die "failed to determine extension id"
	fi

	if [[ -n ${MOZEXTENSION_TARGET} ]]; then
		insinto "${MOZILLA_FIVE_HOME}"/${MOZEXTENSION_TARGET%/}/${emid}
	elif $(mozversion_extension_location) ; then
		insinto "${MOZILLA_FIVE_HOME}"/browser/extensions/${emid}
	else
		insinto "${MOZILLA_FIVE_HOME}"/extensions/${emid}
	fi
	doins -r "${x}"/* || die "failed to copy extension"
}

xpi_copy() {
	local emid

	# You must tell xpi_install which xpi to use
	[[ ${#} -ne 1 ]] && die "$FUNCNAME takes exactly one argument, please specify an xpi to unpack"

	x="${1}"
	#cd ${x}
	# determine id for extension
	if [[ -f "${x}"/install.rdf ]]; then
		emid="$(sed -n -e '/install-manifest/,$ { /em:id/!d; s/.*[\">]\([^\"<>]*\)[\"<].*/\1/; p; q }' "${x}"/install.rdf)"
		[[ -z "${emid}" ]] && die "failed to determine extension id from install.rdf"
	elif [[ -f "${x}"/manifest.json ]]; then
		emid="$(sed -n 's/.*"id": "\([^"]*\)".*/\1/p' "${x}"/manifest.json)"
		[[ -z "${emid}" ]] && die "failed to determine extension id from manifest.json"
	else
		die "failed to determine extension id"
	fi

	if [[ -n ${MOZEXTENSION_TARGET} ]]; then
		insinto "${MOZILLA_FIVE_HOME}"/${MOZEXTENSION_TARGET%/}
	elif $(mozversion_extension_location) ; then
		insinto "${MOZILLA_FIVE_HOME}"/browser/extensions
	else
		insinto "${MOZILLA_FIVE_HOME}"/extensions
	fi

	newins "${DISTDIR%/}"/${x##*/}.xpi ${emid}.xpi
}

_MOZEXTENSION=1
fi
