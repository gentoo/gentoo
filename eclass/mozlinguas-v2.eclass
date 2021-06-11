# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mozlinguas-v2.eclass
# @MAINTAINER:
# mozilla@gentoo.org
# @AUTHOR:
# Nirbheek Chauhan <nirbheek@gentoo.org>
# Ian Stakenvicius <axs@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Handle language packs for mozilla products
# @DESCRIPTION:
# Sets IUSE according to MOZ_LANGS (language packs available). Also exports
# src_unpack, src_compile and src_install for use in ebuilds, and provides
# supporting functions for langpack generation and installation.

inherit mozextension

case "${EAPI:-0}" in
	6)
		inherit eapi7-ver ;;
	7)
		;;
	*)
		die "EAPI ${EAPI} is not supported, contact eclass maintainers" ;;
esac

EXPORT_FUNCTIONS src_unpack src_compile src_install

# @ECLASS-VARIABLE: MOZ_LANGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing the list of language pack xpis available for
# this release. The list can be updated with scripts/get_langs.sh from the
# mozilla overlay.
: ${MOZ_LANGS:=()}

# @ECLASS-VARIABLE: MOZ_PV
# @DEFAULT_UNSET
# @DESCRIPTION:
# Ebuild package version converted to equivalent upstream version.
# Defaults to ${PV}, and should be overridden for alphas, betas, and RCs
: ${MOZ_PV:="${PV}"}

# @ECLASS-VARIABLE: MOZ_PN
# @DEFAULT_UNSET
# @DESCRIPTION:
# Ebuild package name converted to equivalent upstream name.
# Defaults to ${PN}, and should be overridden for binary ebuilds.
: ${MOZ_PN:="${PN}"}

# @ECLASS-VARIABLE: MOZ_P
# @DEFAULT_UNSET
# @DESCRIPTION:
# Ebuild package name + version converted to upstream equivalent.
# Defaults to ${MOZ_PN}-${MOZ_PV}
: ${MOZ_P:="${MOZ_PN}-${MOZ_PV}"}

# @ECLASS-VARIABLE: MOZ_FTP_URI
# @DEFAULT_UNSET
# @DESCRIPTION:
# The ftp URI prefix for the release tarballs and language packs.
: ${MOZ_FTP_URI:=""}

# @ECLASS-VARIABLE: MOZ_HTTP_URI
# @PRE_INHERIT
# @DESCRIPTION:
# The http URI prefix for the release tarballs and language packs.
: ${MOZ_HTTP_URI:=""}

# @ECLASS-VARIABLE: MOZ_LANGPACK_HTTP_URI
# @PRE_INHERIT
# @DESCRIPTION:
# An alternative http URI if it differs from official mozilla URI.
# Defaults to whatever MOZ_HTTP_URI was set to.
: ${MOZ_LANGPACK_HTTP_URI:=${MOZ_HTTP_URI}}

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
# @PRE_INHERIT
# @DEFAULT_UNSET
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
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# The full URI prefix of the distfile for each l10n locale.  The
# AB_CD and MOZ_L10N_URI_SUFFIX will be appended to this to complete the
# SRC_URI when MOZ_GENERATE_LANGPACKS is set.  If empty, nothing will
# be added to SRC_URI.
# Defaults to empty.
: ${MOZ_L10N_URI_PREFIX:=""}

# @ECLASS-VARIABLE: MOZ_L10N_URI_SUFFIX
# @DEFAULT_UNSET
# @DESCRIPTION:
# The suffix of l10n source distfiles.
# Defaults to '.tar.xz'
: ${MOZ_L10N_URI_SUFFIX:=".tar.xz"}

# @ECLASS-VARIABLE: MOZ_FORCE_UPSTREAM_L10N
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this to use upstream langpaks even if the package normally
# shouldn't (ie it is an alpha or beta package)
: ${MOZ_FORCE_UPSTREAM_L10N:=""}

# @ECLASS-VARIABLE: MOZ_TOO_REGIONALIZED_FOR_L10N
# @INTERNAL
# @DESCRIPTION:
# Upstream identifiers that should not contain region subtags in L10N
MOZ_TOO_REGIONALIZED_FOR_L10N=( fy-NL ga-IE gu-IN hi-IN hy-AM nb-NO nn-NO pa-IN sv-SE )

# @ECLASS-VARIABLE: MOZ_INSTALL_L10N_XPIFILE
# @DESCRIPTION:
# Install langpacks as .xpi file instead of unpacked directory.
# Leave unset to install unpacked
: ${MOZ_INSTALL_L10N_XPIFILE:=""}

# Add l10n_* to IUSE according to available language packs
# No language packs for alphas and betas
if ! [[ -n ${MOZ_GENERATE_LANGPACKS} ]] ; then
	if ! [[ ${PV} =~ alpha|beta ]] || { [[ ${PN} == seamonkey ]] && ! [[ ${PV} =~ alpha ]] ; } || [[ -n ${MOZ_FORCE_UPSTREAM_L10N} ]] ; then
	[[ -z ${MOZ_FTP_URI} ]] && [[ -z ${MOZ_LANGPACK_HTTP_URI} ]] && die "No URI set to download langpacks, please set one of MOZ_{FTP,HTTP_LANGPACK}_URI"
	for x in "${MOZ_LANGS[@]}" ; do
		# en and en_US are handled internally
		if [[ ${x} == en ]] || [[ ${x} == en-US ]]; then
			continue
		fi
		# strip region subtag if $x is in the list
		if has ${x} "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			xflag=${x%%-*}
		else
			xflag=${x}
		fi
		SRC_URI+=" l10n_${xflag/[_@]/-}? ("
		[[ -n ${MOZ_FTP_URI} ]] && SRC_URI+="
			${MOZ_FTP_URI}/${MOZ_LANGPACK_PREFIX}${x}${MOZ_LANGPACK_SUFFIX} -> ${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi"
		[[ -n ${MOZ_LANGPACK_HTTP_URI} ]] && SRC_URI+="
			${MOZ_LANGPACK_HTTP_URI}/${MOZ_LANGPACK_PREFIX}${x}${MOZ_LANGPACK_SUFFIX} -> ${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi"
		SRC_URI+=" )"
		IUSE+=" l10n_${xflag/[_@]/-}"
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
		# strip region subtag if $x is in the list
		if has ${x} "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			xflag=${x%%-*}
		else
			xflag=${x}
		fi
# Do NOT grab l10n sources from hg tip at this time, since it is a moving target
#		if [[ ${PV} =~ alpha ]]; then
#			# Please note that this URI is not deterministic - digest breakage could occur
#			SRC_URI+=" l10n_${xflag/[_@]/-}? ( http://hg.mozilla.org/releases/l10n/mozilla-aurora/ach/archive/tip.tar.bz2 -> ${MOZ_P}-l10n-${x}.tar.bz2 )"
#		elif [[ ${PV} =~ beta ]] && ! [[ ${PN} == seamonkey ]]; then
#			# Please note that this URI is not deterministic - digest breakage could occur
#			SRC_URI+=" l10n_${xflag/[_@]/-}? ( http://hg.mozilla.org/releases/l10n/mozilla-beta/ach/archive/tip.tar.bz2 -> ${MOZ_P}-l10n-${x}.tar.bz2 )"
#		elif [[ -n ${MOZ_L10N_URI_PREFIX} ]]; then
		if [[ -n ${MOZ_L10N_URI_PREFIX} ]]; then
			SRC_URI+=" l10n_${xflag/[_@]/-}? ( ${MOZ_L10N_URI_PREFIX}${x}${MOZ_L10N_URI_SUFFIX} )"
		fi
		IUSE+=" l10n_${xflag/[_@]/-}"
	done
fi
unset x xflag

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
	local lingua lflag
	mozlinguas=()
	# Set mozlinguas based on the enabled l10n_* USE flags.
	for lingua in "${MOZ_LANGS[@]}"; do
		# strip region subtag if $x is in the list
		if has ${lingua} en en-US; then
			# For mozilla products, en and en_US are handled internally
			continue
		elif has ${lingua} "${MOZ_TOO_REGIONALIZED_FOR_L10N[@]}" ; then
			lflag=${lingua%%-*}
		else
			lflag=${lingua}
		fi
		use l10n_${lflag/[_@]/-} && mozlinguas+=( ${lingua} )
	done
	# Compatibility code - Check LINGUAS and warn if anything set there isn't enabled via l10n
	for lingua in ${LINGUAS}; do
		if has ${lingua//[_@]/-} en en-US; then
			# For mozilla products, en and en_US are handled internally
			continue
		# If this language is supported by ${P},
		elif has ${lingua} "${MOZ_LANGS[@]//-/_}"; then
			# Warn the language is missing, if it isn't already there
			has ${lingua//[_@]/-} "${mozlinguas[@]//[_@]/-}" || \
				ewarn "LINGUAS value ${lingua} is not enabled using L10N use flags"
			continue
		# For each short lingua that isn't in MOZ_LANGS,
		# We used to add *all* long MOZ_LANGS to the mozlinguas list,
		# but we stopped doing that due to bug 325195.
		else
			:
		fi
		einfo "Sorry, but ${P} does not support the ${lingua} locale in LINGUAS"
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
# For the phase function export
mozlinguas-v2_src_unpack() {
	mozlinguas_src_unpack
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
				if [[ "$(ver_cut 2)" -gt 53 ]] || { [[ "$(ver_cut 2)" -eq 53 ]] && [[ "$(ver_cut 3)" -ge 6 ]] ; } ; then
					localedir+="/comm"
				fi
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

# For the phase function export
mozlinguas-v2_src_compile() {
	mozlinguas_src_compile
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

# @FUNCTION: mozlinguas-v2_src_install
# @DESCRIPTION:
# Install xpi language packs according to the user's L10N settings
# NOTE - uses ${BUILD_OBJ_DIR} or PWD if unset, for source-generated langpacks
mozlinguas_src_install() {
	local x
	mozlinguas_export
	if [[ -n ${MOZ_GENERATE_LANGPACKS} ]] && [[ -n ${mozlinguas[*]} ]]; then
		local repopath="${WORKDIR}/${PN}-generated-langpacks"
		mkdir -p "${repopath}" || die
		pushd "${BUILD_OBJ_DIR:-.}"/dist/*/xpi > /dev/null || die
		for x in "${mozlinguas[@]}"; do
			cp "${MOZ_P}.${x}.langpack.xpi" \
			"${repopath}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi" || die
			xpi_unpack "${repopath}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}.xpi"
		done
		popd > /dev/null || die
	fi

	for x in "${mozlinguas[@]}"; do
		if [[ -n ${MOZ_INSTALL_L10N_XPIFILE} ]]; then
			xpi_copy "${WORKDIR}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}"
		else
			xpi_install "${WORKDIR}/${MOZ_P}-${x}${MOZ_LANGPACK_UNOFFICIAL:+.unofficial}"
		fi
	done
}

# For the phase function export
mozlinguas-v2_src_install() {
	mozlinguas_src_install
}
