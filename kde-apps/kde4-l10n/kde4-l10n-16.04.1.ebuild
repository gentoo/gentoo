# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-l10n"
inherit kde4-base

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://l10n.kde.org"

KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-devel/gettext
"
RDEPEND="
	!minimal? ( !kde-apps/kde-l10n )
	minimal? ( >=kde-apps/kde-l10n-${PV} )
"

REMOVE_DIRS="${FILESDIR}/${PN}-16.03.91-remove-dirs"
REMOVE_MSGS="${FILESDIR}/${PN}-16.03.91-remove-messages"

LV="4.14.3"
LEGACY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB es et eu fa fi fr ga gl
he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru
sk sl sr sv tr ug uk wa zh_CN zh_TW"

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar ast bg bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga
gl he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro
ru sk sl sr sv tr ug uk wa zh_CN zh_TW"

IUSE="+minimal test $(printf 'linguas_%s ' ${MY_LANGS})"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
LURI_BASE="mirror://kde/stable/${LV}/src/${KMNAME}"
SRC_URI=""

for MY_LANG in ${LEGACY_LANGS} ; do
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${LURI_BASE}/${KMNAME}-${MY_LANG}-${LV}.tar.xz )"
done

for MY_LANG in ${MY_LANGS} ; do
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE}/${KMNAME}-${MY_LANG}-${PV}.tar.xz )"
done

S="${WORKDIR}"

pkg_setup() {
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
	[[ -n ${A} ]] && kde4-base_pkg_setup
}

src_unpack() {
	for my_tar in ${A}; do
		[[ ${my_tar} = *${PV}* ]] && local subdir="/4"
		use minimal && [[ ${my_tar} = *${LV}* ]] && continue
		tar -xpf "${DISTDIR}/${my_tar}" --xz \
			"${my_tar/.tar.xz/}/CMakeLists.txt" "${my_tar/.tar.xz/}${subdir}" 2> /dev/null ||
			elog "${my_tar}: tar extract command failed at least partially - continuing"
	done
}

src_prepare() {
	default
	[[ -n ${A} ]] || return

	# add all linguas to cmake
	cat <<-EOF > CMakeLists.txt || die
project(kde4-l10n)
cmake_minimum_required(VERSION 2.8.12)
$(printf "add_subdirectory( %s )\n" `find . -mindepth 1 -maxdepth 1 -type d -name "*${PV}*"`)
EOF

	# Drop KF5-based part
	find -maxdepth 2 -type f -name CMakeLists.txt -exec \
		sed -i -e "/add_subdirectory(5)/ s/^/#DONT/" {} + || die

	if use minimal; then
		einfo "Removing file collisions with Plasma 5 and Applications"
		use test && einfo "Tests enabled: Listing LINGUAS causing file collisions"

		einfo "Directories..."
		while read path; do
			if use test ; then	# build a report w/ LINGUAS="*" to submit @upstream
				local lngs
				for lng in ${LINGUAS}; do
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
				einfo "F: ${path}"	# run with LINGUAS="*" to cut down list
			fi
		done < <(grep -ve "^$\|^\s*\#" "${REMOVE_DIRS}")
		einfo
		einfo "Messages..."
		while read path; do
			if use test ; then	# build a report w/ LINGUAS="*" to submit @upstream
				local lngs
				for lng in ${LINGUAS}; do
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
				einfo "F: ${path}"	# run with LINGUAS="*" to cut down list
			fi
		done < <(grep -ve "^$\|^\s*\#" "${REMOVE_MSGS}")
	else
		local LNG LDIR
		for LNG in ${LINGUAS}; do
			LDIR="${KMNAME}-${LNG}-${LV}"
			if [[ -d "${KMNAME}-${LNG}-${PV}" && -d "${LDIR}" ]] ; then
				einfo "${LNG}: Adding legacy localisation"
				local dest_path
				# Step through directories alphabetically first
				for path in $(ls -R "${LDIR}" | grep ":$" | sed -e 's/:$//') ; do
					dest_path="${path/${LV}/${PV}/4/${LNG}}"
					if [[ ! -d "${dest_path}" ]] ; then
						einfo "   $(basename ${dest_path}) subdirectory"\
							"added to $(basename $(dirname ${dest_path}))"
						mkdir "${dest_path}" || die "Failed creating ${dest_path}"
						echo "add_subdirectory($(basename ${dest_path}))" >> \
							$(dirname "${dest_path}")/CMakeLists.txt
					fi
				done
				einfo "   merging legacy localisation..."
				for path in $(find "${LDIR}" -type f) ; do
					dest_path="${path/${LV}/${PV}/4/${LNG}}"
					cp -rn "${path}" "${dest_path}" || die "Failed copying ${path}"
				done
				# Disable kdepim
				for path in kdepim kdepimlibs kdepim-runtime ; do
					find "${S}/${KMNAME}-${LNG}-${PV}/4/${LNG}" -name CMakeLists.txt -type f -exec \
						sed -i -e "s:^ *add_subdirectory( *${path} *):# no ${path}:g" {} +
				done
				rm -rf "${LDIR}"
			fi
		done
	fi
}

src_configure() {
	mycmakeargs=(
		-DBUILD_docs=$(usex handbook)
	)
	[[ -n ${A} ]] && kde4-base_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde4-base_src_compile
}

src_test() { :; }

src_install() {
	[[ -n ${A} ]] && kde4-base_src_install
}
