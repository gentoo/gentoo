# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: mozlinguas.eclass
# @MAINTAINER:
# mozilla@gentoo.org
# @AUTHOR:
# Nirbheek Chauhan <nirbheek@gentoo.org>
# Ian Stakenvicius <axs@gentoo.org>
# @BLURB: Handle language packs for mozilla products
# @DESCRIPTION:
# Sets IUSE according to MOZ_LANGS (language packs available). Also exports
# src_unpack, src_compile and src_install for use in ebuilds, and provides
# supporting functions for langpack generation and installation.

inherit mozextension

case "${EAPI:-0}" in
	0|1)
		die "EAPI ${EAPI:-0} does not support the '->' SRC_URI operator";;
	2|3|4|5|6)
		EXPORT_FUNCTIONS src_unpack src_compile src_install;;
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

# @ECLASS-VARIABLE: MOZ_HTTP_URI
# @DESCRIPTION:
# The http URI prefix for the release tarballs and language packs.
: ${MOZ_HTTP_URI:=""}

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

# @ECLASS-VARIABLE: MOZ_LANGPACK_UNOFFICIAL
# @DESCRIPTION:
# The status of the langpack, used to differentiate within
# Manifests and on Gentoo mirrors as to when the langpacks are
# generated officially by Mozilla or if they were generated
# unofficially by others (ie the Gentoo mozilla team).  When
# this var is set, the distfile will have a .unofficial.xpi
# suffix.
: ${MOZ_LANGPACK_UNOFFICIAL:=""}

# @ECLASS-VARIABLE: MOZ_GENERATE_LANGPACKS
# @DESCRIPTION:
# This flag specifies whether or not the langpacks should be
# generated directly during the build process, rather than
# being downloaded and installed from upstream pre-built
# extensions.  Primarily it supports pre-release builds.
# Defaults to empty.
: ${MOZ_GENERATE_LANGPACKS:=""}

# @ECLASS-VARIABLE: MOZ_L10N_SOURCEDIR
# @DESCRIPTION:
# The path that l10n sources can be found at, once unpacked.
# Defaults to ${WORKDIR}/l10n-sources
: ${MOZ_L10N_SOURCEDIR:="${WORKDIR}/l10n-sources"}

# @ECLASS-VARIABLE: MOZ_L10N_URI_PREFIX
# @DESCRIPTION:
# The full URI prefix of the distfile for each l10n locale.  The
# AB_CD and MOZ_L10N_URI_SUFFIX will be appended to this to complete the
# SRC_URI when MOZ_GENERATE_LANGPACKS is set.  If empty, nothing will
# be added to SRC_URI.
# Defaults to empty.
: ${MOZ_L10N_URI_PREFIX:=""}

# @ECLASS-VARIABLE: MOZ_L10N_URI_SUFFIX
# @DESCRIPTION:
# The suffix of l10n source distfiles.
# Defaults to '.tar.xz'
: ${MOZ_L10N_URI_SUFFIX:=".tar.xz"}

# Add linguas_* to IUSE according to available language packs
# No language packs for alphas and betas
if ! [[ -n ${MOZ_GENERATE_LANGPACKS} ]] ; then
	if ! [[ ${PV} =~ alpha|beta ]] || { [[ ${PN} == seamonkey ]] && ! [[ ${PV} =~ alpha ]] ; } ; then
	[[ -z ${MOZ_FTP_URI} ]] && [[ -z ${MOZ_HTTP_URI} ]] && die "No URI set to download langpacks, please set one of MOZ_{FTP,HTTP}_URI"
	for x in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${x} == en ]] || [[ ${x} == en-US ]]; then
			continue
		fi
		SRC_URI+=" linguas_${x/-/_}? ("
		[[ -n ${MOZ_FTP_URI} ]] && SRC_URI+="
			${MOZ_FTP_URI}/${MOZ_LANGPACK_PREFIX}${x}${MOZ_LANGPACK_SUFFIX} -> ${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi"
		[[ -n ${MOZ_HTTP_URI} ]] && SRC_URI+="
			${MOZ_HTTP_URI}/${MOZ_LANGPACK_PREFIX}${x}${MOZ_LANGPACK_SUFFIX} -> ${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi"
		SRC_URI+=" )"
		IUSE+=" linguas_${x/-/_}"
		# We used to do some magic if specific/generic locales were missing, but
		# we stopped doing that due to bug 325195.
	done
	fi
else
	for x in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${x} == en ]] || [[ ${x} == en-US ]]; then
			continue
		fi
# Do NOT grab l10n sources from hg tip at this time, since it is a moving target
#		if [[ ${PV} =~ alpha ]]; then
#			# Please note that this URI is not deterministic - digest breakage could occur
#			SRC_URI+=" linguas_${x/-/_}? ( http://hg.mozilla.org/releases/l10n/mozilla-aurora/ach/archive/tip.tar.bz2 -> ${MOZ_P}-l10n-${x}.tar.bz2 )"
#		elif [[ ${PV} =~ beta ]] && ! [[ ${PN} == seamonkey ]]; then
#			# Please note that this URI is not deterministic - digest breakage could occur
#			SRC_URI+=" linguas_${x/-/_}? ( http://hg.mozilla.org/releases/l10n/mozilla-beta/ach/archive/tip.tar.bz2 -> ${MOZ_P}-l10n-${x}.tar.bz2 )"
#		elif [[ -n ${MOZ_L10N_URI_PREFIX} ]]; then
		if [[ -n ${MOZ_L10N_URI_PREFIX} ]]; then
			SRC_URI+=" linguas_${x/-/_}? ( ${MOZ_L10N_URI_PREFIX}${x}${MOZ_L10N_URI_SUFFIX} )"
		fi
		IUSE+=" linguas_${x/-/_}"
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
		[[ ${PV} =~ alpha ]] && ! [[ -n ${MOZ_GENERATE_LANGPACKS} ]] && return
	else
		[[ ${PV} =~ alpha|beta ]] && ! [[ -n ${MOZ_GENERATE_LANGPACKS} ]] && return
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
	if ! [[ -n ${MOZ_GENERATE_LANGPACKS} ]]; then
		mozlinguas_export
		for x in "${mozlinguas[@]}"; do
			# FIXME: Add support for unpacking xpis to portage
			xpi_unpack "${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi"
		done
		if [[ "${mozlinguas[*]}" != "" && "${mozlinguas[*]}" != "en" ]]; then
			einfo "Selected language packs (first will be default): ${mozlinguas[*]}"
		fi
	fi
}

# @FUNCTION: mozlinguas_mozconfig
# @DESCRIPTION:
# if applicable, add the necessary flag to .mozconfig to support
# the generation of locales.  Note that this function requires
# mozconfig_annontate to already be declared via an inherit of
# mozconfig or mozcoreconf.
mozlinguas_mozconfig() {
	if [[ -n ${MOZ_GENERATE_LANGPACKS} ]]; then
		if declare -f mozconfig_annotate >/dev/null ; then
			mozconfig_annotate 'for building locales' --with-l10n-base=${MOZ_L10N_SOURCEDIR}
		else
			die "Could not configure l10n-base, mozconfig_annotate not declared -- missing inherit?"
		fi
	fi
}

# @FUNCTION: mozlinguas_src_compile
# @DESCRIPTION:
# if applicable, build the selected locales.
mozlinguas_src_compile() {
	if [[ -n ${MOZ_GENERATE_LANGPACKS} ]]; then
		# leverage BUILD_OBJ_DIR if set otherwise assume PWD.
		local x y targets=( "langpack" ) localedir="${BUILD_OBJ_DIR:-.}"
		case ${PN} in
			*firefox)
				localedir+="/browser/locales"
				;;
			seamonkey)
				localedir+="/suite/locales"
				;;
			*thunderbird)
				localedir+="/mail/locales"
				targets+=( "calendar-langpack" )
				;;
			*) die "Building locales for ${PN} is not supported."
		esac
		pushd "${localedir}" > /dev/null || die
		mozlinguas_export
		for x in "${mozlinguas[@]}"; do for y in "${targets[@]}"; do
			emake ${y}-${x} LOCALE_MERGEDIR="./${y}-${x}"
		done; done
		popd > /dev/null || die
	fi
}

# @FUNCTION: mozlinguas_xpistage_langpacks
# @DESCRIPTION:
# Add extra langpacks to the xpi-stage dir for prebuilt plugins
#
# First argument is the path to the extension
# Second argument is the prefix of the source (same as first if unspecified)
# Remaining arguments are the modules in the extension that are localized
#  (basename of first if unspecified)
#
# Example - installing extra langpacks for lightning:
# src_install() {
# 	... # general installation steps
# 	mozlinguas_xpistage_langpacks \
#		"${BUILD_OBJ_DIR}"/dist/xpi-stage/lightning \
#		"${WORKDIR}"/lightning \
#		lightning calendar
#	... # proceed with installation from the xpi-stage dir
# }

mozlinguas_xpistage_langpacks() {
	local l c modpath="${1}" srcprefix="${1}" modules=( "${1##*/}" )
	shift
	if [[ -n ${1} ]] ; then srcprefix="${1}" ; shift ; fi
	if [[ -n ${1} ]] ; then modules=( $@ ) ; fi

	mozlinguas_export
	mkdir -p "${modpath}/chrome" || die
	for l in "${mozlinguas[@]}"; do	for c in "${modules[@]}" ; do
		if [[ -e "${srcprefix}-${l}/chrome/${c}-${l}" ]]; then
			cp -RLp -t "${modpath}/chrome" "${srcprefix}-${l}/chrome/${c}-${l}" || die
			grep "locale ${c} ${l} chrome/" "${srcprefix}-${l}/chrome.manifest" \
				>>"${modpath}/chrome.manifest" || die
		elif [[ -e "${srcprefix}/chrome/${c}-${l}" ]]; then
			cp -RLp -t "${modpath}/chrome" "${srcprefix}/chrome/${c}-${l}" || die
			grep "locale ${c} ${l} chrome/" "${srcprefix}/chrome.manifest" \
				>>"${modpath}/chrome.manifest" || die
		else
			ewarn "Locale ${l} was not found for ${c}, skipping."
		fi
	done; done
}

# @FUNCTION: mozlinguas_src_install
# @DESCRIPTION:
# Install xpi language packs according to the user's LINGUAS settings
# NOTE - uses ${BUILD_OBJ_DIR} or PWD if unset, for source-generated langpacks
mozlinguas_src_install() {
	local x
	mozlinguas_export
	if [[ -n ${MOZ_GENERATE_LANGPACKS} ]]; then
		local repopath="${WORKDIR}/${PN}-generated-langpacks"
		mkdir -p "${repopath}"
		pushd "${BUILD_OBJ_DIR:-.}"/dist/*/xpi > /dev/null || die
		for x in "${mozlinguas[@]}"; do
			cp "${MOZ_P}.${x}.langpack.xpi" \
			"${repopath}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi" || die
			xpi_unpack "${repopath}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi"
		done
		popd > /dev/null || die
	fi
	for x in "${mozlinguas[@]}"; do
		xpi_install "${WORKDIR}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}"
	done
}
