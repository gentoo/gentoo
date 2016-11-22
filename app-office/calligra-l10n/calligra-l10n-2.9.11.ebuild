# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Calligra localization package"
HOMEPAGE="https://www.kde.org/"
LICENSE="GPL-2"

DEPEND="sys-devel/gettext"
RDEPEND="!app-office/koffice-l10n"

KEYWORDS="amd64 ~arm x86"
IUSE="doc"

MY_LANGS="bs ca ca@valencia cs da de el en_GB es et fi fr gl hu it ja kk nb nl
pl pt pt_BR ru sk sv tr uk zh_CN zh_TW"

case ${PV} in
	2.[456789].[789]?)
		# beta or rc releases
		URI_BASE="mirror://kde/unstable/${PN/-l10n/}-${PV}/${PN}" ;;
	2.[456789].?|2.[456789].??)
		# stable releases
		URI_BASE="mirror://kde/stable/${PN/-l10n/}-${PV}/${PN}" ;;
	*)
		SRC_URI="" ;;
esac

SRC_URI=""
SLOT="4"

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} l10n_${MY_LANG/[@_]/-}"
	SRC_URI="${SRC_URI} l10n_${MY_LANG/[@_]/-}? ( ${URI_BASE}/${PN}-${MY_LANG}-${PV}.tar.xz )"
done
unset MY_LANG

S="${WORKDIR}"

src_unpack() {
	local lng dir
	if [[ -z ${A} ]]; then
		elog
		elog "None of the requested L10N are supported by ${P}."
		elog
		elog "${P} supports these language codes:"
		elog "${MY_LANGS//[@_]/-}"
		elog
	fi

	[[ -n ${A} ]] && unpack ${A}
	cd "${S}"

	# add all L10N to cmake
	if [[ -n ${A} ]]; then
		for lng in ${MY_LANGS}; do
			dir="${PN}-${lng}-${PV}"
			if [[ -d "${dir}" ]] ; then
				echo "add_subdirectory( ${dir} )" >> "${S}"/CMakeLists.txt
			fi
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MESSAGES=ON -DBUILD_DATA=ON
		$(cmake-utils_use_build doc)
	)
	[[ -e "${S}"/CMakeLists.txt ]] && kde4-base_src_configure
}

src_compile() {
	[[ -e "${S}"/CMakeLists.txt ]] && kde4-base_src_compile
}

src_test() {
	[[ -e "${S}"/CMakeLists.txt ]] && kde4-base_src_test
}

src_install() {
	[[ -e "${S}"/CMakeLists.txt ]] && kde4-base_src_install
}
