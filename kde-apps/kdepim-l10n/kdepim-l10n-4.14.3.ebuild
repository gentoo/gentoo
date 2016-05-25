# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK=optional
inherit kde4-base

DESCRIPTION="KDE PIM internationalization package"
HOMEPAGE="http://l10n.kde.org"

DEPEND="
	sys-devel/gettext
"
RDEPEND=""

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

MY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB es et eu fa fi fr ga gl he
hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru sk
sl sr sv tr ug uk wa zh_CN zh_TW"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
SRC_URI=""

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE/kdepim/kde}/kde-l10n-${MY_LANG}-${PV}.tar.xz )"
done

S="${WORKDIR}"

src_unpack() {
	local LNG DIR
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

	# For EAPI >= 3, or if not using .tar.xz archives:
	[[ -n ${A} ]] && unpack ${A}
	cd "${S}"

	# add all linguas to cmake
	if [[ -n ${A} ]]; then
		for LNG in ${LINGUAS}; do
			DIR="kde-l10n-${LNG}-${PV}"
			if [[ -d "${DIR}" ]] ; then
				echo "add_subdirectory( ${DIR} )" >> "${S}"/CMakeLists.txt
			fi

			# remove everything except kdepim and kdepim-runtime
			for SUBDIR in data docs messages scripts ; do
				if [[ -d "${S}/${DIR}/${SUBDIR}" ]] ; then
					einfo "   ${SUBDIR} subdirectory"
					echo > "${S}/${DIR}/${SUBDIR}/CMakeLists.txt"
					[[ -d "${S}/${DIR}/${SUBDIR}/kdepim" ]] && ( echo "add_subdirectory(kdepim)" >> "${S}/${DIR}/${SUBDIR}/CMakeLists.txt" )
					[[ -d "${S}/${DIR}/${SUBDIR}/kdepim-runtime" ]] && ( echo "add_subdirectory(kdepim-runtime)" >> "${S}/${DIR}/${SUBDIR}/CMakeLists.txt" )
				fi
			done

			# in some cases we may have sub-lingua subdirs, e.g. sr :(
			for XSUBDIR in "${S}/${DIR}/${LNG}"@* ; do
				XLNG=$(echo ${XSUBDIR}|sed -e 's:^.*/::')
				if [[ -d "${XSUBDIR}" ]] ; then
					einfo "   ${XLNG} variant"
					# remove everything except kdepim and kdepim-runtime
					for SUBDIR in data docs messages scripts ; do
						if [[ -d "${XSUBDIR}/${SUBDIR}" ]] ; then
							einfo "      ${SUBDIR} subdirectory"
							echo > "${XSUBDIR}/${SUBDIR}/CMakeLists.txt"
							[[ -d "${XSUBDIR}/${SUBDIR}/kdepim" ]] && ( echo "add_subdirectory(kdepim)" >> "${XSUBDIR}/${SUBDIR}/CMakeLists.txt" )
							[[ -d "${XSUBDIR}/${SUBDIR}/kdepim-runtime" ]] && ( echo "add_subdirectory(kdepim-runtime)" >> "${XSUBDIR}/${SUBDIR}/CMakeLists.txt" )
						fi
					done
				fi
			done
		done
	fi
}

src_prepare() {
	[[ -n ${A} ]] && kde4-base_src_prepare
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
