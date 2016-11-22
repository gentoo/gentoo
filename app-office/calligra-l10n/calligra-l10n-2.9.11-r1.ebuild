# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-base

DESCRIPTION="Calligra localization package"
HOMEPAGE="https://www.kde.org/"
LICENSE="GPL-2"
SLOT="4"

KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

DEPEND="sys-devel/gettext"
RDEPEND="!app-office/koffice-l10n"

CAL_FTS="braindump flow karbon kexi krita plan sheets stage words"
for cal_ft in ${CAL_FTS}; do
	IUSE+=" calligra_features_${cal_ft}"
done
unset cal_ft

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

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} l10n_${MY_LANG/[@_]/-}"
	SRC_URI="${SRC_URI} l10n_${MY_LANG/[@_]/-}? ( ${URI_BASE}/${PN}-${MY_LANG}-${PV}.tar.xz )"
done
unset MY_LANG

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
}

src_unpack() {
	[[ -n ${A} ]] && unpack ${A}
}

src_prepare() {
	cat <<-EOF > CMakeLists.txt || die
project(${PN})
$(printf "add_subdirectory( %s )\n" \
	`find . -mindepth 1 -maxdepth 1 -type d | sed -e "s:^\./::"`)
EOF

	local cal_ft
	for cal_ft in ${CAL_FTS}; do
		if ! use calligra_features_${cal_ft} ; then
			if ls -U ./*/messages/calligra/${cal_ft}*po > /dev/null 2>&1; then
				rm ./*/messages/calligra/${cal_ft}*po || \
					die "Failed to remove ${cal_ft} messages"
			fi
			if ls -U ./*/docs/calligra/${cal_ft} > /dev/null 2>&1; then
				sed -e "\:add_subdirectory(\s*${cal_ft}\s*): s:^:#:" \
					-i ./*/docs/calligra/CMakeLists.txt || \
					die "Failed to comment out ${cal_ft} docs"
			fi
		fi
	done

	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DATA=ON
		-DBUILD_DOC=$(usex doc)
		-DBUILD_MESSAGES=ON
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
