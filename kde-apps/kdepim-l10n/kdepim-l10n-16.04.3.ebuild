# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KDE_L10N=(
	ar ast bg bs ca ca-valencia cs da de el en-GB eo es et eu fa fi fr ga gl he
	hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt-BR ro ru
	sk sl sr sr-ijekavsk sr-Latn sr-Latn-ijekavsk sv tr ug uk wa zh-CN zh-TW
)
KMNAME="kde-l10n"
inherit kde5

DESCRIPTION="KDE PIM internationalization package"

KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep linguist-tools)
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-15.08.0-r1
	!<kde-apps/kde4-l10n-4.14.3-r1
"

PIM_L10N="kdepim kdepimlibs kdepim-runtime pim"

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

	# Remove everything except kdepim, kdepimlibs, kdepim-runtime and pim
	for lng in ${KDE_L10N[@]}; do
		local dir sdir
		dir="kde-l10n-$(kde_l10n2lingua ${lng})-${PV}"
		sdir="${S}/${dir}/5/$(kde_l10n2lingua ${lng})"
		if [[ -d "${dir}" ]] ; then
			einfo " L10N: ${lng}"

			for subdir in data docs messages scripts ; do
				if [[ -d "${sdir}/${subdir}" ]] ; then
					einfo "   ${subdir} subdirectory"
					echo > "${sdir}/${subdir}/CMakeLists.txt"
					for pim in ${PIM_L10N}; do
						[[ -d "${sdir}/${subdir}/${pim}" ]] && \
							( echo "add_subdirectory(${pim})" >> "${sdir}/${subdir}/CMakeLists.txt" )
					done
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
