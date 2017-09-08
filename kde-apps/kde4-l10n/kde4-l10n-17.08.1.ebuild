# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KDE_L10N=(
	ar ast bg bs ca ca-valencia cs da de el en-GB eo es et eu fa fi fr ga gl he
	hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt-BR ro ru
	sk sl sr sr-ijekavsk sr-Latn sr-Latn-ijekavsk sv tr ug uk wa zh-CN zh-TW
)
inherit kde4-base

DESCRIPTION="KDE legacy internationalization package"
HOMEPAGE="https://l10n.kde.org"

kde_l10n2lingua() {
	local l
	for l; do
		case ${l} in
			ca-valencia) echo ca@valencia;;
			sr-ijekavsk) echo sr@ijekavian;;
			sr-Latn-ijekavsk) echo sr@ijekavianlatin;;
			sr-Latn) echo sr@latin;;
			uz-Cyrl) echo uz@cyrillic;;
			*) echo "${l/-/_}";;
		esac
	done
}

URI_BASE="${SRC_URI/kde4-l10n-${PV}.tar.xz/}kde-l10n/kde-l10n"
SRC_URI=""
for my_l10n in ${KDE_L10N[@]} ; do
	case ${my_l10n} in
		sr | sr-ijekavsk | sr-Latn-ijekavsk | sr-Latn)
			SRC_URI="${SRC_URI} l10n_${my_l10n}? ( ${URI_BASE}-sr-${PV}.tar.xz )"
			;;
		*)
			SRC_URI="${SRC_URI} l10n_${my_l10n}? ( ${URI_BASE}-$(kde_l10n2lingua ${my_l10n})-${PV}.tar.xz )"
			;;
	esac
done
unset URI_BASE

KEYWORDS="~amd64 ~arm ~x86"

DEPEND="
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/akonadi-search-17.04.1:5
	!kde-apps/kde-l10n:5
	!<kde-apps/khelpcenter-17.04.1:5
	!<kde-apps/kio-extras-17.04.1:5
	!<kde-apps/umbrello-17.08.0:5
	!<kde-frameworks/baloo-5.34.0:5
	!<kde-frameworks/baloo-widgets-5.34.0:5
	!<kde-frameworks/kfilemetadata-5.34.0:5
	!<kde-plasma/kde-cli-tools-5.10.0:5
	!<kde-plasma/plasma-desktop-5.10.0:5
	!<kde-plasma/plasma-workspace-5.10.0:5
"

REMOVE_DIRS="${FILESDIR}/${PN}-16.12.3-remove-dirs"

IUSE="test $(printf 'l10n_%s ' ${KDE_L10N[@]})"

S="${WORKDIR}"

pkg_setup() {
	if [[ -z ${A} ]]; then
		elog
		elog "None of the requested L10N are supported by ${P}."
		elog
		elog "${P} supports these language codes:"
		elog "${KDE_L10N[@]}"
		elog
	fi
	[[ -n ${A} ]] && kde4-base_pkg_setup
}

src_unpack() {
	for my_tar in ${A}; do
		tar -xpf "${DISTDIR}/${my_tar}" --xz \
			"${my_tar/.tar.xz/}/CMakeLists.txt" "${my_tar/.tar.xz/}/4" 2> /dev/null ||
			elog "${my_tar}: tar extract command failed at least partially - continuing"
	done
}

src_prepare() {
	# move known variant subdirs to root dir, currently sr@*
	use_if_iuse l10n_sr-ijekavsk && l10n_variant_subdir2root sr-ijekavsk sr
	use_if_iuse l10n_sr-Latn-ijekavsk && l10n_variant_subdir2root sr-Latn-ijekavsk sr
	use_if_iuse l10n_sr-Latn && l10n_variant_subdir2root sr-Latn sr
	if use_if_iuse l10n_sr; then
		rm -rf kde-l10n-sr-${PV}/4/sr/sr@* || die "Failed to cleanup L10N=sr"
		l10n_variant_subdir_buster sr
	elif [[ -d kde-l10n-sr-${PV} ]]; then
		# having any variant selected means parent lingua will be unpacked as well
		rm -r kde-l10n-sr-${PV} || die "Failed to remove sr parent lingua"
	fi

	cat <<-EOF > CMakeLists.txt || die
	project(${PN})
	cmake_minimum_required(VERSION 2.8.12)
	EOF
	# add all l10n directories to cmake
	if [[ -n ${A} ]]; then
		cat <<-EOF >> CMakeLists.txt || die
		$(printf "add_subdirectory( %s )\n" \
			`find . -mindepth 1 -maxdepth 1 -type d | sed -e "s:^\./::"`)
		EOF
	fi

	kde4-base_src_prepare
	[[ -n ${A} ]] || return

	einfo "Removing file collisions with Plasma 5 and Applications"
	[[ -f ${REMOVE_DIRS} ]] || die "Error: ${REMOVE_DIRS} not found!"

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
}

src_configure() {
	local mycmakeargs=(
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

l10n_variant_subdir2root() {
	local lingua=$(kde_l10n2lingua ${1})
	local src=kde-l10n-${2}-${PV}
	local dest=kde-l10n-${lingua}-${PV}/4

	# create variant rootdir structure from parent lingua and adapt it
	mkdir -p ${dest} || die "Failed to create ${dest}"
	mv ${src}/4/${2}/${lingua} ${dest}/${lingua} || die "Failed to create ${dest}/${lingua}"
	cp -f ${src}/CMakeLists.txt kde-l10n-${lingua}-${PV} || die "Failed to prepare L10N=${1} subdir"
	echo "add_subdirectory(${lingua})" > ${dest}/CMakeLists.txt ||
		die "Failed to prepare ${dest}/CMakeLists.txt"
	cp -f ${src}/4/${2}/CMakeLists.txt ${dest}/${lingua} ||
		die "Failed to create ${dest}/${lingua}/CMakeLists.txt"
	sed -e "s/${2}/${lingua}/" -i ${dest}/${lingua}/CMakeLists.txt ||
		die "Failed to prepare ${dest}/${lingua}/CMakeLists.txt"

	l10n_variant_subdir_buster ${1}
}

l10n_variant_subdir_buster() {
	local dir=kde-l10n-$(kde_l10n2lingua ${1})-${PV}/4/$(kde_l10n2lingua ${1})

	sed -e "/^macro.*subdirectory(/d" -i ${dir}/CMakeLists.txt || die "Failed to cleanup ${dir} subdir"

	for subdir in $(find ${dir} -mindepth 1 -maxdepth 1 -type d | sed -e "s:^\./::"); do
		if [[ ${subdir##*/} != "cmake_modules" ]] ; then
			echo "add_subdirectory(${subdir##*/})" >> ${dir}/CMakeLists.txt || die
		fi
	done
}
