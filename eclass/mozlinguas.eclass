# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mozlinguas.eclass,v 1.6 2013/04/05 15:27:40 floppym Exp $

# @ECLASS: mozlinguas.eclass
# @MAINTAINER:
# mozilla@gentoo.org
# @AUTHOR:
# Nirbheek Chauhan <nirbheek@gentoo.org>
# @BLURB: Handle language packs for mozilla products
# @DESCRIPTION:
# Sets IUSE according to MOZ_LANGS (language packs available). Also exports
# src_unpack and src_install for use in ebuilds.

inherit mozextension

case "${EAPI:-0}" in
	0|1)
		die "EAPI ${EAPI:-0} does not support the '->' SRC_URI operator";;
	2|3|4|5)
		EXPORT_FUNCTIONS src_unpack src_install;;
	*)
		die "EAPI ${EAPI} is not supported, contact eclass maintainers";;
esac

# @ECLASS-VARIABLE: MOZ_LANGS
# @DESCRIPTION:
# Array containing the list of language pack xpis available for
# this release. The list can be updated with scripts/get_langs.sh from the
# mozilla overlay.
: ${MOZ_LANGS:=()}

# @ECLASS-VARIABLE: MOZ_PV
# @DESCRIPTION:
# Ebuild package version converted to equivalent upstream version.
# Defaults to ${PV}, and should be overridden for alphas, betas, and RCs
: ${MOZ_PV:="${PV}"}

# @ECLASS-VARIABLE: MOZ_PN
# @DESCRIPTION:
# Ebuild package name converted to equivalent upstream name.
# Defaults to ${PN}, and should be overridden for binary ebuilds.
: ${MOZ_PN:="${PN}"}

# @ECLASS-VARIABLE: MOZ_P
# @DESCRIPTION:
# Ebuild package name + version converted to upstream equivalent.
# Defaults to ${MOZ_PN}-${MOZ_PV}
: ${MOZ_P:="${MOZ_PN}-${MOZ_PV}"}

# @ECLASS-VARIABLE: MOZ_FTP_URI
# @DESCRIPTION:
# The ftp URI prefix for the release tarballs and language packs.
: ${MOZ_FTP_URI:=""}

# @ECLASS-VARIABLE: MOZ_LANGPACK_PREFIX
# @DESCRIPTION:
# The relative path till the lang code in the langpack file URI.
# Defaults to ${MOZ_PV}/linux-i686/xpi/
: ${MOZ_LANGPACK_PREFIX:="${MOZ_PV}/linux-i686/xpi/"}

# @ECLASS-VARIABLE: MOZ_LANGPACK_SUFFIX
# @DESCRIPTION:
# The suffix after the lang code in the langpack file URI.
# Defaults to '.xpi'
: ${MOZ_LANGPACK_SUFFIX:=".xpi"}

# Add linguas_* to IUSE according to available language packs
# No language packs for alphas and betas
if ! [[ ${PV} =~ alpha|beta ]] || { [[ ${PN} == seamonkey ]] && ! [[ ${PV} =~ alpha ]] ; } ; then
	for x in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${x} == en ]] || [[ ${x} == en-US ]]; then
			continue
		fi
		SRC_URI+="
			linguas_${x/-/_}?
				( ${MOZ_FTP_URI}/${MOZ_LANGPACK_PREFIX}${x}${MOZ_LANGPACK_SUFFIX} -> ${MOZ_P}-${x}.xpi )"
		IUSE+=" linguas_${x/-/_}"
		# We used to do some magic if specific/generic locales were missing, but
		# we stopped doing that due to bug 325195.
	done
fi
unset x

# @FUNCTION: mozlinguas_export
# @INTERNAL
# @DESCRIPTION:
# Generate the list of language packs called "mozlinguas"
# This list is used to unpack and install the xpi language packs
mozlinguas_export() {
	if [[ ${PN} == seamonkey ]] ; then
		[[ ${PV} =~ alpha ]] && return
	else
		[[ ${PV} =~ alpha|beta ]] && return
	fi
	local lingua
	mozlinguas=()
	for lingua in ${LINGUAS}; do
		if has ${lingua} en en_US; then
			# For mozilla products, en and en_US are handled internally
			continue
		# If this language is supported by ${P},
		elif has ${lingua} "${MOZ_LANGS[@]//-/_}"; then
			# Add the language to mozlinguas, if it isn't already there
			has ${lingua//_/-} "${mozlinguas[@]}" || mozlinguas+=(${lingua//_/-})
			continue
		# For each short lingua that isn't in MOZ_LANGS,
		# We used to add *all* long MOZ_LANGS to the mozlinguas list,
		# but we stopped doing that due to bug 325195.
		else
			:
		fi
		ewarn "Sorry, but ${P} does not support the ${lingua} locale"
	done
}

# @FUNCTION: mozlinguas_src_unpack
# @DESCRIPTION:
# Unpack xpi language packs according to the user's LINGUAS settings
mozlinguas_src_unpack() {
	local x
	mozlinguas_export
	for x in "${mozlinguas[@]}"; do
		# FIXME: Add support for unpacking xpis to portage
		xpi_unpack "${MOZ_P}-${x}.xpi"
	done
	if [[ "${mozlinguas[*]}" != "" && "${mozlinguas[*]}" != "en" ]]; then
		einfo "Selected language packs (first will be default): ${mozlinguas[*]}"
	fi
}

# @FUNCTION: mozlinguas_src_install
# @DESCRIPTION:
# Install xpi language packs according to the user's LINGUAS settings
mozlinguas_src_install() {
	local x
	mozlinguas_export
	for x in "${mozlinguas[@]}"; do
		xpi_install "${WORKDIR}/${MOZ_P}-${x}"
	done
}
