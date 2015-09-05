# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-l10n"
inherit kde4-base

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://l10n.kde.org"

DEPEND="
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-${PV}
"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="minimal"

REMOVE_DIRS="${FILESDIR}/${PN}-15.07.90-remove-dirs"
REMOVE_MSGS="${FILESDIR}/${PN}-15.08.0-remove-messages"

LV="4.14.3"
LEGACY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB es et eu fa fi fr ga gl
he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru
sk sl sr sv tr ug uk wa zh_CN zh_TW"

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga gl
he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru
sk sl sr sv tr ug uk wa zh_CN zh_TW"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
LURI_BASE="mirror://kde/stable/${LV}/src/${KMNAME}"
SRC_URI=""

for MY_LANG in ${LEGACY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${LURI_BASE}/${KMNAME}-${MY_LANG}-${LV}.tar.xz )"
done

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE}/${KMNAME}-${MY_LANG}-${PV}.tar.xz )"
done

S="${WORKDIR}"

src_unpack() {
	if [[ -z ${A} ]]; then
		elog
		elog "You either have the LINGUAS variable unset, or it only"
		elog "contains languages not supported by ${P}."
		elog "You won't have any additional language support."
		elog
		elog "${P} supports these language codes:"
		elog "${MY_LANGS}"
		elog
	fi

	[[ -n ${A} ]] && unpack ${A}
}

src_prepare() {
	local LNG DIR SDIR
	# add all linguas to cmake
	if [[ -n ${A} ]]; then
		for LNG in ${LINGUAS}; do
			DIR="${KMNAME}-${LNG}-${PV}"
			SDIR="${S}/${DIR}/4/${LNG}"
			if [[ -d "${DIR}" ]] ; then
				echo "add_subdirectory( ${DIR} )" >> "${S}"/CMakeLists.txt

				# Drop KF5-based part
				sed -e '/add_subdirectory(5)/ s/^/#/' -i "${S}"/${DIR}/CMakeLists.txt

				# Drop translations installed with plasma 5 and kde-apps 5 packages
				if use minimal; then
					einfo "Removing paths from ${LNG}"
					if [[ -d "${KMNAME}-${LNG}-${LV}" ]] ; then
						rm -rf "${KMNAME}-${LNG}-${LV}"
					fi

					# Remove dirs
					while read path; do
						if [[ -n ${path} && -e "${SDIR}"/${path%\ *}/CMakeLists.txt ]] ; then
							sed -e ":${path#*\ }: s:^:#:"\
								-i "${SDIR}"/${path%\ *}/CMakeLists.txt
						fi
					done < <(grep -v "^#" "${REMOVE_DIRS}")

					# Remove messages
					for path in $(grep -v "^#" "${REMOVE_MSGS}") ; do
						rm -f "${SDIR}"/messages/${path}
						# Quirk for LINGUAS=sr variants
						if [[ ${LNG} = "sr" ]] ; then
							rm -f "${SDIR}"/${LNG}\@*/messages/${path} || die
						fi
					done
				else
					if [[ -d "${KMNAME}-${LNG}-${LV}" ]] ; then
						# Do not try to copy kdepim localisation
						for path in kdepim kdepimlibs kdepim-runtime; do
							rm -rf "${KMNAME}-${LNG}-${LV}/messages/${path}" || die
						done
						# Merge legacy localisation
						for path in $(find "${KMNAME}-${LNG}-${LV}" -name "*.po"); do
							cp -rn "${path}" "${path/${LV}/${PV}/4/${LNG}}" || die
						done
						rm -rf "${KMNAME}-${LNG}-${LV}"
					fi
				fi
			fi
		done
	fi

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build handbook docs)
	)
	[[ -n ${A} ]] && kde4-base_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde4-base_src_compile
}

src_test() {
	[[ -n ${A} ]] && kde4-base_src_test
}

src_install() {
	[[ -n ${A} ]] && kde4-base_src_install
}
