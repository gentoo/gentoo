# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

BASE_PV=$(ver_cut 1-3)
MY_PV="${PV/_alpha/.alpha}"
MY_PV="${MY_PV/_beta/.beta}"
[[ ${PV} == *alpha* || ${PV} == *beta* ]] && PN_DEV="Dev"

DESCRIPTION="Translations for the Libreoffice suite"
HOMEPAGE="https://www.libreoffice.org"
BASE_SRC_URI_TESTING="https://download.documentfoundation.org/${PN/-l10n/}/testing/${BASE_PV}/rpm"
BASE_SRC_URI_STABLE="https://download.documentfoundation.org/${PN/-l10n/}/stable/${BASE_PV}/rpm"

LICENSE="|| ( LGPL-3 MPL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="offlinehelp"

#
# when changing the language lists, please be careful to preserve the spaces (bug 491728)
#
# "en:en-US" for mapping from Gentoo "en" to upstream "en-US" etc.
LANGUAGES_HELP=" am ast bg bn-IN bn bo bs ca-valencia ca cs da de dz el en-GB en:en-US en-ZA eo es et eu fi fr gl gu he hi hr hu id is it ja ka km ko mk nb ne nl nn om pl pt-BR pt ru si sk sl sq sv tg tr ug uk vi zh-CN zh-TW "
LANGUAGES="${LANGUAGES_HELP}af ar as be br brx cy dgo fa ga gd gug kk kmr-Latn kn kok ks lb lo lt lv mai ml mn mni mr my nr nso oc or pa:pa-IN ro rw sa:sa-IN sat sd sid sr-Latn sr ss st sw-TZ ta te th tn ts tt uz ve xh zu "

for lang in ${LANGUAGES_HELP}; do
	helppack="offlinehelp? ( ${BASE_SRC_URI_STABLE}/x86_64/LibreOffice${PN_DEV}_${BASE_PV}_Linux_x86-64_rpm_helppack_${lang#*:}.tar.gz -> LibreOffice_${MY_PV}_Linux_x86-64_rpm_helppack_${lang#*:}.tar.gz ${BASE_SRC_URI_TESTING}/x86_64/LibreOffice${PN_DEV}_${MY_PV}_Linux_x86-64_rpm_helppack_${lang#*:}.tar.gz -> LibreOffice_${MY_PV}_Linux_x86-64_rpm_helppack_${lang#*:}.tar.gz )"
	SRC_URI+=" l10n_${lang%:*}? ( ${helppack} )"
done
for lang in ${LANGUAGES}; do
	if [[ ${lang%:*} != en ]]; then
		langpack="${BASE_SRC_URI_STABLE}/x86_64/LibreOffice${PN_DEV}_${BASE_PV}_Linux_x86-64_rpm_langpack_${lang#*:}.tar.gz -> LibreOffice_${MY_PV}_Linux_x86-64_rpm_langpack_${lang#*:}.tar.gz ${BASE_SRC_URI_TESTING}/x86_64/LibreOffice${PN_DEV}_${MY_PV}_Linux_x86-64_rpm_langpack_${lang#*:}.tar.gz -> LibreOffice_${MY_PV}_Linux_x86-64_rpm_langpack_${lang#*:}.tar.gz"
		SRC_URI+=" l10n_${lang%:*}? ( ${langpack} )"
	fi
	IUSE+=" l10n_${lang%:*}"
done
unset lang helppack langpack

RDEPEND+="app-text/hunspell"

RESTRICT="strip"

S="${WORKDIR}"

src_prepare() {
	default

	local lang dir rpmdir

	# First remove dictionaries, we want to use system ones.
	find "${S}" -name *dict*.rpm -delete || die "Failed to remove dictionaries"

	for lang in ${LANGUAGES}; do
		# break away if not enabled
		use l10n_${lang%:*} || continue

		dir=${lang#*:}

		# for english we provide just helppack, as translation is always there
		if [[ ${lang%:*} != en ]]; then
			rpmdir="LibreOffice_${MY_PV}_Linux_x86-64_rpm_langpack_${dir}/RPMS/"
			[[ -d ${rpmdir} ]] || die "Missing directory: ${rpmdir}"
			rpm_unpack ./${rpmdir}/*.rpm
		fi
		if [[ "${LANGUAGES_HELP}" =~ " ${lang} " ]] && use offlinehelp; then
			rpmdir="LibreOffice_${MY_PV}_Linux_x86-64_rpm_helppack_${dir}/RPMS/"
			[[ -d ${rpmdir} ]] || die "Missing directory: ${rpmdir}"
			rpm_unpack ./${rpmdir}/*.rpm
		fi
	done
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	local dir="${S}"/opt/${PN/-l10n/}$(ver_cut 1-2)/
	# Condition required for people who do not install anything e.g. no l10n
	# or just english with no offlinehelp.
	if [[ -d "${dir}" ]] ; then
		insinto /usr/$(get_libdir)/${PN/-l10n/}/
		doins -r "${dir}"/*
	fi
	# remove extensions that are in l10n for some weird reason
	rm -rf "${ED}"/usr/$(get_libdir)/${PN/-l10n/}/share/extensions/ || \
		die "Failed to remove extensions"
}
