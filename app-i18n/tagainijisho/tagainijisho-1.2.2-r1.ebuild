# Copyright 2014-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake xdg-utils

DESCRIPTION="Open-source Japanese dictionary and kanji lookup tool"
HOMEPAGE="https://www.tagaini.net/ https://github.com/Gnurou/tagainijisho"
SRC_URI="https://github.com/Gnurou/${PN}/releases/download/${PV}/${PN}-${PV}.tar.gz"
LICENSE="GPL-3+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_ar l10n_cs l10n_de l10n_es l10n_fa l10n_fi l10n_fr l10n_hr l10n_hu l10n_id l10n_it l10n_nb l10n_nl l10n_no l10n_pl l10n_pt l10n_ru l10n_sv l10n_ta l10n_th l10n_tr l10n_uk l10n_vi l10n_zh"

BDEPEND="dev-qt/linguist-tools:5"

DEPEND=">=dev-db/sqlite-3.40:3
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.2-cmake-4.1-compatibility.patch"
)

src_configure() {
	# GUI linguae
	# en is not optional, and build fails if none other than en is set, so adding ja as non-optional too.
	local lang use_lang
	for lang in i18n/*.ts; do
		lang=${lang#i18n/tagainijisho_}
		lang=${lang%.ts}
		case ${lang} in
			es_AR|fa_IR|fi_FI|pt_BR|zh_TW)
				# Use generic tags.
				use_lang=${lang%%_*}
				;;
			*)
				use_lang=${lang}
				;;
		esac

		if [[ ${lang} != en && ${lang} != ja ]] && ! use l10n_${use_lang}; then
			rm i18n/tagainijisho_${lang}.ts || die
		fi
	done

	# Dictionary linguae
	# en is not optional here either, but nothing special needs to be done.
	local dict_langs
	for lang in $(sed -e 's/;/ /g' -ne '/set(DICT_LANG ".*")/s/.*"\(.*\)".*/\1/p' CMakeLists.txt); do
		if use l10n_${lang}; then
			dict_langs+="${dict_langs:+;}${lang}"
		fi
	done

	local mycmakeargs=(
		-DDICT_LANG="${dict_langs:-;}"
		-DEMBED_SQLITE=OFF
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
