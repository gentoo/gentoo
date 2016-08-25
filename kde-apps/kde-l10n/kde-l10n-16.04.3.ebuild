# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
KDE_L10N=(
	ar ast bg bs ca ca-valencia cs da de el en-GB eo es et eu fa fi fr ga gl he
	hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt-BR ro ru
	sk sl sr sr-ijekavsk sr-Latn sr-Latn-ijekavsk sv tr ug uk wa zh-CN zh-TW
)
inherit kde5

DESCRIPTION="KDE internationalization package"

KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep linguist-tools)
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde4-l10n-${PV}
	!<kde-apps/kdepim-l10n-${PV}:5
	!<kde-apps/khelpcenter-5.5.5-r1
	!=kde-apps/khelpcenter-5.6.2
	!<kde-apps/ktp-l10n-${PV}
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

	# Handbook optional
	find -type f -name CMakeLists.txt -exec \
		sed -i -e "/find_package.*KF5DocTools/ s/ REQUIRED//" {} + || die
	if ! use handbook ; then
		find -mindepth 4 -maxdepth 4 -type f -name CMakeLists.txt -exec \
			sed -i -e '/add_subdirectory(docs)/ s/^/#DONT/' {} + || die
	fi

	# Remove kdepim translations (part of kde-apps/kdepim-l10n)
	for subdir in kdepim kdepimlibs kdepim-runtime pim; do
		find -mindepth 5 -maxdepth 5 -type f -name CMakeLists.txt -exec \
			sed -i -e "/add_subdirectory( *${subdir} *)/ s/^/#DONT/" {} + || die
	done

	# Remove ktp translations (part of kde-apps/ktp-l10n)
	# Drop that hack (and kde-apps/ktp-l10n) after ktp:4 removal
	find ./*/5/*/messages/kdenetwork -type f \
		\( -name kaccounts*po -o -name kcm_ktp*po -o -name kcmtelepathy*po \
		-o -name kded_ktp*po -o -name ktp*po -o -name plasma*ktp*po \) \
		-delete
}

src_configure() {
	[[ -n ${A} ]] && kde5_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde5_src_compile
}

src_test() { :; }

src_install() {
	[[ -n ${A} ]] && kde5_src_install
}
