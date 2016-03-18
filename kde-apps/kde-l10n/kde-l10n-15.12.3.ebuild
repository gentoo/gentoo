# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://l10n.kde.org"

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep linguist-tools)
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde4-l10n-${PV}
	!kde-apps/kde4-l10n[-minimal]
	!<kde-apps/kdepim-l10n-${PV}
	!<kde-apps/ktp-l10n-${PV}
"

KEYWORDS="~amd64 ~x86"
IUSE=""

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga gl
he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru
sk sl sr sv tr ug uk wa zh_CN zh_TW"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
SRC_URI=""

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE}/${PN}-${MY_LANG}-${PV}.tar.xz )"
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
	default

	local LNG DIR
	# add all linguas to cmake
	if [[ -n ${A} ]]; then
		for LNG in ${LINGUAS}; do
			DIR="${PN}-${LNG}-${PV}"
			if [[ -d "${DIR}" ]] ; then
				echo "add_subdirectory( ${DIR} )" >> "${S}"/CMakeLists.txt

				# Drop KDE4-based part
				sed -e '/add_subdirectory(4)/ s/^/#/'\
					-i "${S}"/${DIR}/CMakeLists.txt || die

				# Remove kdepim translations (part of kde-apps/kdepim-l10n)
				for subdir in kdepim kdepimlibs kdepim-runtime pim; do
					find "${S}/${DIR}" -name CMakeLists.txt -type f \
						-exec sed -i -e "/add_subdirectory( *${subdir} *)/ s/^/#/" {} +
				done

				# Remove ktp translations (part of kde-apps/ktp-l10n)
				# Drop that hack (and kde-apps/ktp-l10n) after ktp:4 removal
				find "${S}"/${DIR}/5/${LNG}/messages/kdenetwork -type f \
					\( -name kaccounts*po -o -name kcm_ktp*po -o -name kcmtelepathy*po \
					-o -name kded_ktp*po -o -name ktp*po -o -name plasma*ktp*po \) \
					-delete

				# Handbook optional
				sed -e '/KF5DocTools/ s/ REQUIRED//'\
					-i "${S}"/${DIR}/5/${LNG}/CMakeLists.txt || die
				if ! use handbook ; then
					sed -e '/add_subdirectory(docs)/ s/^/#/'\
						-i "${S}"/${DIR}/5/${LNG}/CMakeLists.txt || die
				fi
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
