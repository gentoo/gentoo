# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
KDE_MINIMAL="4.6"

inherit kde4-base

DESCRIPTION="KDE PIM internationalization package"
HOMEPAGE="http://l10n.kde.org"

DEPEND="
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-15.08.0-r1
	!<kde-apps/kde4-l10n-4.14.3-r1
"

KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

MY_LANGS="ar bg ca ca@valencia cs csb da de el en_GB eo es et eu
		fi fr fy ga gl gu he hi hr hu id is it ja kk km kn ko lt lv
		mai mk ml nb nds nl nn pa pl pt pt_BR ro ru si sk sl sr sv tg
		tr uk wa zh_CN zh_TW"

PIM_L10N="kdepim kdepimlibs"

URI_BASE="mirror://kde/Attic/4.4.5/src/kde-l10n"
SRC_URI=""

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} l10n_${MY_LANG/[@_]/-}"
	SRC_URI="${SRC_URI} l10n_${MY_LANG/[@_]/-}? ( ${URI_BASE}/kde-l10n-${MY_LANG}-4.4.5.tar.bz2 )"
done

S="${WORKDIR}"

src_unpack() {
	local LNG DIR
	if [[ -z ${A} ]]; then
		elog
		elog "None of the requested L10N are supported by ${P}."
		elog
		elog "${P} supports these language codes:"
		elog "${MY_LANGS//[@_]/-}"
		elog
	fi

	# For EAPI >= 3, or if not using .tar.xz archives:
	[[ -n ${A} ]] && unpack ${A}
	cd "${S}"

	# for all l10n do:
	if [[ -n ${A} ]]; then
		for LNG in ${MY_LANGS}; do
			einfo "Processing ${LNG} localization"
			DIR="kde-l10n-${LNG}-4.4.5"

			# add subdir to toplevel cmake file
			if [[ -d "${DIR}" ]] ; then
				echo "add_subdirectory( ${DIR} )" >> "${S}"/CMakeLists.txt
			fi

			# Remove everything except subdirs defined in PIM_L10N
			for SUBDIR in data docs messages scripts ; do
				if [[ -d "${S}/${DIR}/${SUBDIR}" ]] ; then
					einfo "   ${SUBDIR} subdirectory"
					echo > "${S}/${DIR}/${SUBDIR}/CMakeLists.txt"
					for pim in ${PIM_L10N}; do
						[[ -d "${S}/${DIR}/${SUBDIR}/${pim}" ]] && \
							( echo "add_subdirectory(${pim})" >> "${S}/${DIR}/${SUBDIR}/CMakeLists.txt" )
					done
				fi
			done

			# In some cases we may have sub-lingua subdirs, e.g. sr :(
			for XSUBDIR in "${S}/${DIR}/${LNG}"@* ; do
				XLNG=$(echo ${XSUBDIR}|sed -e 's:^.*/::')
				if [[ -d "${XSUBDIR}" ]] ; then
					einfo "   ${XLNG} variant"
					# Remove everything except subdirs defined in PIM_L10N
					for SUBDIR in data docs messages scripts ; do
						if [[ -d "${XSUBDIR}/${SUBDIR}" ]] ; then
							einfo "      ${SUBDIR} subdirectory"
							echo > "${XSUBDIR}/${SUBDIR}/CMakeLists.txt"
							for pim in ${PIM_L10N}; do
								[[ -d "${XSUBDIR}/${SUBDIR}/${pim}" ]] && \
									( echo "add_subdirectory(${pim})" >> "${XSUBDIR}/${SUBDIR}/CMakeLists.txt" )
							done
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
	mycmakeargs="${mycmakeargs}
		-DBUILD_docs=OFF"
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
