# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KDE_L10N=(
	ar ast bg bs ca ca-valencia cs da de el en-GB eo es et eu fa fi fr ga gl he
	hi hr hu ia is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt-BR ro ru
	sk sl sr sr-ijekavsk sr-Latn sr-Latn-ijekavsk sv tr ug uk wa zh-CN zh-TW
)
KMNAME="kde-l10n"
inherit kde5

DESCRIPTION="KDE PIM internationalization package"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep linguist-tools)
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde-l10n-16.04.3
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
	# Disable all by default, pim dirs are added manually if found
	find -mindepth 4 -maxdepth 4 -type f -name CMakeLists.txt -exec \
		sed -i -e '/^add_subdirectory/ s/^/#ONLYPIM/' {} + || die

	# Remove everything except kdepim, kdepimlibs, kdepim-runtime and pim
	for lng in ${KDE_L10N[@]}; do
		local sdir="${S}/kde-l10n-$(kde_l10n2lingua ${lng})-${PV}/5/$(kde_l10n2lingua ${lng})"
		if [[ -d "${sdir}" ]] ; then
			local gotpim=false
			einfo "L10N: ${lng}"

			for subdir in data docs messages scripts ; do
				if [[ -d "${sdir}/${subdir}" ]] ; then
					rm "${sdir}/${subdir}/CMakeLists.txt" || die
					local pim
					for pim in ${PIM_L10N}; do
						if [[ -d "${sdir}/${subdir}/${pim}" ]]; then
							echo "add_subdirectory(${subdir}/${pim})" >> "${sdir}/CMakeLists.txt"
							gotpim=true
						fi
					done
				fi
			done
			if ! ${gotpim}; then
				einfo "F: ${lng} contains no KDE PIM translations and should be dropped"
				sed -e "/kde-l10n-$(kde_l10n2lingua ${lng})-${PV}/ s/^/#WRONG/" \
					-i CMakeLists.txt || die "Failed to disable no-op ${lng}"
			fi
		fi
	done

	if ! use handbook ; then
		find -mindepth 4 -maxdepth 4 -type f -name CMakeLists.txt -exec \
			sed -i -e '/^add_subdirectory(docs/ s/^/#DONT/' {} + || die
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
	[[ $(grep -sc "^add" CMakeLists.txt) -gt 0 ]] && kde5_src_install
}
