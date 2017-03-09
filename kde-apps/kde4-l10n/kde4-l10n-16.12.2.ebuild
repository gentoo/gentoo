# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_AUTODEPS="false"
KDE_HANDBOOK="optional"
KDE_L10N=(
	ar ast bg bs ca ca-valencia cs da de el en-GB eo es et eu fa fi fr ga gl he
	hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt-BR ro ru
	sk sl sr sr-ijekavsk sr-Latn sr-Latn-ijekavsk sv tr ug uk wa zh-CN zh-TW
)
KMNAME="kde-l10n"
inherit kde5

DESCRIPTION="KDE legacy internationalization package"

SLOT="4"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="
	kde-frameworks/kdelibs:4
	sys-devel/gettext
"
RDEPEND="
	>=kde-apps/kde-l10n-${PV}
"

REMOVE_DIRS="${FILESDIR}/${PN}-16.11.90-remove-dirs"
REMOVE_MSGS="${FILESDIR}/${PN}-16.11.90-remove-messages"

IUSE="aqua test" # TODO: Drop aqua as soon as possible

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

	einfo "Removing file collisions with Plasma 5 and Applications"
	[[ -f ${REMOVE_DIRS} ]] || die "Error: ${REMOVE_DIRS} not found!"
	[[ -f ${REMOVE_MSGS} ]] || die "Error: ${REMOVE_MSGS} not found!"

	use test && einfo "Tests enabled: Listing LINGUAS causing file collisions"

	einfo "Directories..."
	while read path; do
		if use test ; then	# build a report w/ L10N="*" to submit @upstream
			local lngs
			for lng in $(kde_l10n2lingua ${KDE_L10N[@]}); do
				SDIR="${S}/${KMNAME}-${lng}-${PV}/4/${lng}"
				if [[ -d "${SDIR}"/${path%\ *}/${path#*\ } ]] ; then
					lngs+=" ${lng}"
				fi
			done
			[[ -n "${lngs}" ]] && einfo "${path%\ *}/${path#*\ }${lngs}"
			unset lngs
		fi
		if ls -U ./*/4/*/${path%\ *}/${path#*\ } > /dev/null 2>&1; then
			sed -e "\:add_subdirectory(\s*${path#*\ }\s*): s:^:#:" \
				-i ./*/4/*/${path%\ *}/CMakeLists.txt || \
				die "Failed to comment out ${path}"
		else
			einfo "F: ${path}"	# run with L10N="*" to cut down list
		fi
	done < <(grep -ve "^$\|^\s*\#" "${REMOVE_DIRS}")
	einfo
	einfo "Messages..."
	while read path; do
		if use test ; then	# build a report w/ L10N="*" to submit @upstream
			local lngs
			for lng in $(kde_l10n2lingua ${KDE_L10N[@]}); do
				SDIR="${S}/${KMNAME}-${lng}-${PV}/4/${lng}"
				if [[ -e "${SDIR}"/messages/${path} ]] ; then
					lngs+=" ${lng}"
				fi
			done
			[[ -n "${lngs}" ]] && einfo "${path}${lngs}"
			unset lngs
		fi
		if ls -U ./*/4/*/messages/${path} > /dev/null 2>&1; then
			rm ./*/4/*/messages/${path} || die "Failed to remove ${path}"
		else
			einfo "F: ${path}"	# run with L10N="*" to cut down list
		fi
	done < <(grep -ve "^$\|^\s*\#" "${REMOVE_MSGS}")
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_docs=$(usex handbook)
	)
	[[ -n ${A} ]] && kde5_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde5_src_compile
}

src_test() { :; }

src_install() {
	[[ -n ${A} ]] && kde5_src_install
}
