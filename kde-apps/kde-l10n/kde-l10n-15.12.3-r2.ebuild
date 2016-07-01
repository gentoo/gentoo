# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde5 multibuild

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://l10n.kde.org"

KEYWORDS="amd64 x86"

KHC_PV="5.6.2"
KHC="khelpcenter-${KHC_PV}"

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_qt_dep linguist-tools)
	sys-devel/gettext
"
RDEPEND="
	!<kde-apps/kde4-l10n-${PV}
	!kde-apps/kde4-l10n[-minimal]
	!<kde-apps/kdepim-l10n-${PV}:5
	!<kde-apps/khelpcenter-5.5.5-r1
	!=kde-apps/khelpcenter-5.6.2
	!<kde-apps/ktp-l10n-${PV}
"

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga gl
he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru
sk sl sr sv tr ug uk wa zh_CN zh_TW"

IUSE="$(printf 'l10n_%s ' ${MY_LANGS//[_@]/-})"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
SRC_URI="mirror://kde/stable/plasma/${KHC_PV}/${KHC}.tar.xz"
for my_lang in ${MY_LANGS} ; do
	SRC_URI="${SRC_URI} l10n_${my_lang//[_@]/-}? ( ${URI_BASE}/${PN}-${my_lang}-${PV}.tar.xz )"
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
	MULTIBUILD_VARIANTS=( l10n khelpcenter-l10n )
	[[ -n ${A} ]] && kde5_pkg_setup
}

src_unpack() {
	for my_tar in ${A}; do
		if [[ ${my_tar} = ${KHC}.tar.xz ]] ; then
			tar -xpf "${DISTDIR}/${my_tar}" --xz \
				"${my_tar/.tar.xz/}/CMakeLists.txt" "${my_tar/.tar.xz/}" 2> /dev/null ||
				elog "${my_tar}: tar extract command failed at least partially - continuing"
		else
			tar -xpf "${DISTDIR}/${my_tar}" --xz \
				"${my_tar/.tar.xz/}/CMakeLists.txt" "${my_tar/.tar.xz/}/5" 2> /dev/null ||
				elog "${my_tar}: tar extract command failed at least partially - continuing"
		fi
	done
}

src_prepare() {
	default
	[[ ${L10N} = "" ]] && return

	# add all l10n to cmake
	cat <<-EOF > CMakeLists.txt || die
project(kde-l10n)
cmake_minimum_required(VERSION 2.8.12)
if(BUILD_KHELPCENTER_L10N)
add_subdirectory( ${KHC} )
else()
$(printf "  add_subdirectory( %s )\n" \
	`find . -mindepth 1 -maxdepth 1 -type d -name "kde-l10n*" | sed -e "s:^\./::"`)
endif()
EOF

	# add khelpcenter po generation
	cat <<-EOF > ${KHC}/CMakeLists.txt || die
project(khelpcenter-l10n)
cmake_minimum_required(VERSION 2.8.12)
find_package(KF5I18n CONFIG REQUIRED)
ki18n_install(po)
EOF

	if [[ -d ${KHC}/po ]] ; then
		pushd ${KHC}/po > /dev/null || die
		for lang in *; do
			if [[ -d ${lang} ]] && ! has "${lang/[@_]/-}" ${L10N} ; then
				rm -r ${lang} || die
				if [[ -e CMakeLists.txt ]] ; then
					cmake_comment_add_subdirectory ${lang}
				fi
			fi
		done
		popd > /dev/null || die
	fi

	# Drop KDE4-based part
	find -maxdepth 2 -type f -name CMakeLists.txt -exec \
		sed -i -e "/add_subdirectory(4)/ s/^/#DONT/" {} + || die

	# Handbook optional
	find -type f -name CMakeLists.txt -exec \
		sed -i -e "/find_package.*KF5DocTools/ s/ REQUIRED//" {} + || die
	if ! use handbook ; then
		find -mindepth 4 -maxdepth 4 -type f -name CMakeLists.txt -exec \
			sed -i -e '/add_subdirectory(docs)/ s/^/#DONT/' {} + || die
	fi

	# Remove scripted translations (part of kde-frameworks/ki18n)
	find -mindepth 5 -maxdepth 5 -type f -name CMakeLists.txt -exec \
		sed -i -e "/add_subdirectory( *frameworks *)/ s/^/#DONT/" {} + || die

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
	myconfigure() {
		local mycmakeargs=()
		if [[ ${MULTIBUILD_VARIANT} = khelpcenter-l10n ]]; then
			mycmakeargs+=(-DBUILD_KHELPCENTER_L10N=ON)
		fi
		kde5_src_configure
	}
	[[ ${L10N} != "" ]] && multibuild_foreach_variant myconfigure
}

src_compile() {
	[[ ${L10N} != "" ]] && multibuild_foreach_variant kde5_src_compile
}

src_test() { :; }

src_install() {
	[[ ${L10N} != "" ]] && multibuild_foreach_variant kde5_src_install
}
