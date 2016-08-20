# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="false"
KDE_L10N=(
	ar ast bg bs ca ca-valencia cs da de el en-GB eo es et eu fa fi fr ga gl he
	hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt-BR ro ru
	sk sl sr sr-ijekavsk sr-Latn sr-Latn-ijekavsk sv tr ug uk wa zh-CN zh-TW
)
KMNAME="kde-l10n"
inherit kde5

DESCRIPTION="KDE Telepathy internationalization package"

KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep linguist-tools)
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-16.04.3
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

pkg_setup() {
	if [[ -z ${A} ]]; then
		elog
		elog "None of the requested L10N are supported by ${P}."
		elog
		elog "${P} supports these language codes:"
		elog "${KDE_L10N[@]}"
		elog
	fi
	[[ -n ${A} ]] && kde5_pkg_setup
}

src_prepare() {
	kde5_src_prepare
	[[ -n ${A} ]] || return

	# We only want messages
	find -mindepth 4 -maxdepth 4 -type f -name CMakeLists.txt -exec \
		sed -i -e "/messages/!s/^add_subdirectory/#DONT/" {} + || die

	# Remove Handbook
	find -type f -name CMakeLists.txt -exec \
		sed -i -e "/find_package.*KF5DocTools/ s/^/#/" {} + || die

	# Remove everything except kdenetwork/ktp translations
	for lng in ${KDE_L10N[@]}; do
		local dir sdir
		dir="kde-l10n-$(kde_l10n2lingua ${lng})-${PV}"
		sdir="${S}/${dir}/5/$(kde_l10n2lingua ${lng})"
		if [[ -d "${dir}" ]] ; then
			einfo " L10N: ${lng}"

			if [[ -d "${sdir}/messages" ]] ; then
				echo > "${sdir}/messages/CMakeLists.txt"
				[[ -d "${sdir}/messages/kdenetwork" ]] && \
					( echo "add_subdirectory(kdenetwork)" >> "${sdir}/messages/CMakeLists.txt" )
				# Remove everything but ktp translations
				find "${sdir}"/messages/kdenetwork -type f ! \( -name CMakeLists.txt \
					-o -name kaccounts*po -o -name kcm_ktp*po -o -name kcmtelepathy*po \
					-o -name kded_ktp*po -o -name ktp*po -o -name plasma*ktp*po \) \
					-delete
			fi
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
