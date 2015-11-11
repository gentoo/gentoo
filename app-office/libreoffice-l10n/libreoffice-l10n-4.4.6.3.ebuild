# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit rpm eutils multilib versionator

MY_PV=$(get_version_component_range 1-3)

DESCRIPTION="Translations for the Libreoffice suite"
HOMEPAGE="http://www.libreoffice.org"
BASE_SRC_URI_TESTING="http://download.documentfoundation.org/${PN/-l10n/}/testing/${MY_PV}/rpm"
BASE_SRC_URI_STABLE="http://download.documentfoundation.org/${PN/-l10n/}/stable/${MY_PV}/rpm"

LICENSE="|| ( LGPL-3 MPL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="offlinehelp"

#
# when changing the language lists, please be careful to preserve the spaces (bug 491728)
#
LANGUAGES_HELP=" am ast bg bn_IN bn bo bs ca_valencia ca cs da de dz el en_GB en en_ZA eo es et eu fi fr gl gu he hi hr hu id is it ja ka km ko mk nb ne nl nn om pl pt_BR pt ru si sk sl sq sv tg tr ug uk vi zh_CN zh_TW "
LANGUAGES="${LANGUAGES_HELP}af ar as be br brx cy dgo fa ga gd kk kmr_Latn kn kok ks lb lo lt lv mai ml mn mni mr my nr nso oc or pa_IN ro rw sa_IN sat sd sid sr_Latn sr ss st sw_TZ ta te th tn ts tt uz ve xh zu "

for lang in ${LANGUAGES_HELP}; do
	helppack=""
	[[ ${lang} == en ]] && lang2=${lang/en/en_US} || lang2=${lang}
	helppack="offlinehelp? ( ${BASE_SRC_URI_STABLE}/x86/LibreOffice_${MY_PV}_Linux_x86_rpm_helppack_${lang2/_/-}.tar.gz -> LibreOffice_${PV}_Linux_x86_rpm_helppack_${lang2/_/-}.tar.gz  ${BASE_SRC_URI_TESTING}/x86/LibreOffice_${PV}_Linux_x86_rpm_helppack_${lang2/_/-}.tar.gz )"
	SRC_URI+=" linguas_${lang}? ( ${helppack} )"
done
for lang in ${LANGUAGES}; do
	langpack=""
	[[ ${lang} == en ]] \
		|| langpack="${BASE_SRC_URI_STABLE}/x86/LibreOffice_${MY_PV}_Linux_x86_rpm_langpack_${lang/_/-}.tar.gz -> LibreOffice_${PV}_Linux_x86_rpm_langpack_${lang/_/-}.tar.gz   ${BASE_SRC_URI_TESTING}/x86/LibreOffice_${PV}_Linux_x86_rpm_langpack_${lang/_/-}.tar.gz"
	[[ -z ${langpack} ]] || SRC_URI+=" linguas_${lang}? ( ${langpack} )"
	IUSE+=" linguas_${lang}"
done
unset lang helppack langpack lang2

RDEPEND+="app-text/hunspell"

RESTRICT="strip"

S="${WORKDIR}"

src_prepare() {
	local lang dir rpmdir

	# First remove dictionaries, we want to use system ones.
	find "${S}" -name *dict*.rpm -delete || die "Failed to remove dictionaries"

	for lang in ${LANGUAGES}; do
		# break away if not enabled; paludis support
		use_if_iuse linguas_${lang} || continue

		dir=${lang/_/-}

		# for english we provide just helppack, as translation is always there
		if [[ ${lang} != en ]]; then
			rpmdir="LibreOffice_${PV}_Linux_x86_rpm_langpack_${dir}/RPMS/"
			[[ -d ${rpmdir} ]] || die "Missing directory: ${rpmdir}"
			rpm_unpack ./${rpmdir}/*.rpm
		fi
		if [[ "${LANGUAGES_HELP}" =~ " ${lang} " ]] && use offlinehelp; then
			[[ ${lang} == en ]] && dir="en-US"
			rpmdir="LibreOffice_${PV}_Linux_x86_rpm_helppack_${dir}/RPMS/"
			[[ -d ${rpmdir} ]] || die "Missing directory: ${rpmdir}"
			rpm_unpack ./${rpmdir}/*.rpm
		fi
	done
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	local dir="${S}"/opt/${PN/-l10n/}$(get_version_component_range 1-2)/
	# Condition required for people that do not install anything eg no linguas
	# or just english with no offlinehelp.
	if [[ -d "${dir}" ]] ; then
		insinto /usr/$(get_libdir)/${PN/-l10n/}/
		doins -r "${dir}"/*
	fi
	# remove extensions that are in the l10n for some weird reason
	rm -rf "${ED}"usr/$(get_libdir)/${PN/-l10n/}/share/extensions/ || \
		die "Failed to remove extensions"
}
