# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="false"
inherit kde5

DESCRIPTION="KDE Telepathy internationalization package"
HOMEPAGE="http://l10n.kde.org"

KEYWORDS="~amd64 ~x86"

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep linguist-tools)
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-15.08.0-r1
	!kde-apps/ktp-accounts-kcm:4
	!kde-apps/ktp-approver:4
	!kde-apps/ktp-auth-handler:4
	!kde-apps/ktp-common-internals:4
	!kde-apps/ktp-contact-list:4
	!kde-apps/ktp-filetransfer-handler:4
	!kde-apps/ktp-kded-module:4
	!kde-apps/ktp-send-file:4
	!kde-apps/ktp-text-ui:4
"

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar ast bg bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga
gl he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro
ru sk sl sr sv tr ug uk wa zh_CN zh_TW"

IUSE="$(printf 'l10n_%s ' ${MY_LANGS//[@_]/-})"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
SRC_URI=""
for MY_LANG in ${MY_LANGS} ; do
	SRC_URI="${SRC_URI} l10n_${MY_LANG/[@_]/-}? ( ${URI_BASE/ktp/kde}/kde-l10n-${MY_LANG}-${PV}.tar.xz )"
done

S="${WORKDIR}"

pkg_setup() {
	if [[ -z ${A} ]]; then
		elog
		elog "None of the requested L10N are supported by ${P}."
		elog
		elog "${P} supports these language codes:"
		elog "${MY_LANGS//[@_]/-}"
		elog
	fi
	[[ -n ${A} ]] && kde5_pkg_setup
}

src_unpack() {
	for my_tar in ${A}; do
		tar -xpf "${DISTDIR}/${my_tar}" --xz \
			"${my_tar/.tar.xz/}/CMakeLists.txt" "${my_tar/.tar.xz/}/5" 2> /dev/null ||
			elog "${my_tar}: tar extract command failed at least partially - continuing"
	done
}

src_prepare() {
	default
	[[ -n ${A} ]] || return

	# add all l10n to cmake
	cat <<-EOF > CMakeLists.txt || die
project(kdepim-l10n)
cmake_minimum_required(VERSION 2.8.12)
$(printf "add_subdirectory( %s )\n" \
	`find . -mindepth 1 -maxdepth 1 -type d | sed -e "s:^\./::"`)
EOF

	# Drop KDE4-based part
	find -maxdepth 2 -type f -name CMakeLists.txt -exec \
		sed -i -e "/add_subdirectory(4)/ s/^/#DONT/" {} + || die
	# We only want messages
	find -mindepth 4 -maxdepth 4 -type f -name CMakeLists.txt -exec \
		sed -i -e "/messages/!s/^add_subdirectory/#DONT/" {} + || die
	# Remove Handbook
	find -type f -name CMakeLists.txt -exec \
		sed -i -e "/find_package.*KF5DocTools/ s/^/#/" {} + || die

	# Remove everything except kdenetwork/ktp translations
	local LNG DIR
	for LNG in ${MY_LANGS}; do
		DIR="kde-l10n-${LNG}-${PV}"
		SDIR="${S}/${DIR}/5/${LNG}"
		if [[ -d "${DIR}" ]] ; then

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
