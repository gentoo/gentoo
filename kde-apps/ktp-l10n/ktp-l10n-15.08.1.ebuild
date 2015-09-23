# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="false"
inherit kde5

DESCRIPTION="KDE Telepathy internationalization package"
HOMEPAGE="http://l10n.kde.org"

DEPEND="
	$(add_frameworks_dep ki18n)
	dev-qt/linguist-tools:5
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-15.08.0-r1
	!net-im/ktp-accounts-kcm
	!net-im/ktp-approver
	!net-im/ktp-auth-handler
	!net-im/ktp-common-internals
	!net-im/ktp-contact-list
	!net-im/ktp-filetransfer-handler
	!net-im/ktp-kded-module
	!net-im/ktp-send-file
	!net-im/ktp-text-ui
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
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE/ktp/kde}/kde-l10n-${MY_LANG}-${PV}.tar.xz )"
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

				# We only want messages
				sed -e '/messages/!s/^add_subdirectory/# DONT/'\
					-i "${SDIR}"/CMakeLists.txt || die

				# Remove everything except kdenetwork
				if [[ -d "${SDIR}/messages" ]] ; then
					echo > "${SDIR}/messages/CMakeLists.txt"
					[[ -d "${SDIR}/messages/kdenetwork" ]] && \
						( echo "add_subdirectory(kdenetwork)" >> "${SDIR}/messages/CMakeLists.txt" )
					# Remove everything but ktp translations
					find "${SDIR}"/messages/kdenetwork -type f ! \( -name CMakeLists.txt \
						-o -name kaccounts*po -o -name kcm_ktp*po -o -name kcmtelepathy*po \
						-o -name kded_ktp*po -o -name ktp*po -o -name plasma*ktp*po \) \
						-delete
				fi

				# In some cases we may have sub-lingua subdirs, e.g. sr :(
				for XSUBDIR in "${SDIR}/${LNG}"@* ; do
					XLNG=$(echo ${XSUBDIR}|sed -e 's:^.*/::')
					if [[ -d "${XSUBDIR}" ]] ; then
						einfo "   ${XLNG} variant"
						# remove everything except kdenetwork
						if [[ -d "${XSUBDIR}/messages" ]] ; then
							echo > "${XSUBDIR}/messages/CMakeLists.txt"
							[[ -d "${XSUBDIR}/messages/kdenetwork" ]] && \
								( echo "add_subdirectory(kdenetwork)" >> "${XSUBDIR}/messages/CMakeLists.txt" )
							# Remove everything but ktp translations
							find "${XSUBDIR}"/messages/kdenetwork -type f ! \( -name CMakeLists.txt \
								-o -name kaccounts*po -o -name kcm_ktp*po -o -name kcmtelepathy*po \
								-o -name kded_ktp*po -o -name ktp*po -o -name plasma*ktp*po \) \
								-delete
						fi
					fi
				done
			fi
		done
	fi
}

src_configure() {
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
