# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="KDE PIM internationalization package"
HOMEPAGE="http://l10n.kde.org"

DEPEND="
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-15.08.0-r1
	!<kde-apps/kde4-l10n-4.14.3-r1
	!kde-base/kdepim-l10n
"

KEYWORDS="~amd64 ~x86"
IUSE=""

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga gl
he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru
sk sl sr sv tr ug uk wa zh_CN zh_TW"

PIM_L10N="kdepim kdepimlibs kdepim-runtime pim"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
SRC_URI=""

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE/kdepim/kde}/kde-l10n-${MY_LANG}-${PV}.tar.xz )"
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
	local LNG DIR
	# add all linguas to cmake
	if [[ -n ${A} ]]; then
		for LNG in ${LINGUAS}; do
			DIR="kde-l10n-${LNG}-${PV}"
			SDIR="${S}/${DIR}/5/${LNG}"
			if [[ -d "${DIR}" ]] ; then
				echo "add_subdirectory( ${DIR} )" >> "${S}"/CMakeLists.txt

				# Drop KDE4-based part
				sed -e '/add_subdirectory(4)/ s/^/#/'\
					-i "${S}"/${DIR}/CMakeLists.txt || die

				# Remove everything except kdepim, kdepimlibs, kdepim-runtime and pim
				for SUBDIR in data docs messages scripts ; do
					if [[ -d "${SDIR}/${SUBDIR}" ]] ; then
						einfo "   ${SUBDIR} subdirectory"
						echo > "${SDIR}/${SUBDIR}/CMakeLists.txt"
						for pim in ${PIM_L10N}; do
							[[ -d "${SDIR}/${SUBDIR}/${pim}" ]] && \
								( echo "add_subdirectory(${pim})" >> "${SDIR}/${SUBDIR}/CMakeLists.txt" )
						done
					fi
				done

				# In some cases we may have sub-lingua subdirs, e.g. sr :(
				for XSUBDIR in "${SDIR}/${LNG}"@* ; do
					XLNG=$(echo ${XSUBDIR}|sed -e 's:^.*/::')
					if [[ -d "${XSUBDIR}" ]] ; then
						einfo "   ${XLNG} variant"
						# remove everything except kdepim and kdepim-runtime
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

				# Handbook optional
				sed -e '/KF5DocTools/ s/ REQUIRED//'\
					-i "${SDIR}"/CMakeLists.txt || die
				if ! use handbook ; then
					sed -e '/add_subdirectory(docs)/ s/^/#/'\
						-i "${SDIR}"/CMakeLists.txt || die
				fi

				# Fix broken LINGUAS=sr (KDE4 leftover)
				if [[ ${LNG} = "sr" ]] ; then
					sed -e '/add_subdirectory(lokalize)/ s/^/#/'\
						-i "${SDIR}"/data/kdesdk/CMakeLists.txt || die
				fi
			fi
		done
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_find_package handbook KF5DocTools)
	)
	[[ -n ${A} ]] && kde5_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde5_src_compile
}

src_test() {
	[[ -n ${A} ]] && kde5_src_test
}

src_install() {
	[[ -n ${A} ]] && kde5_src_install
}
