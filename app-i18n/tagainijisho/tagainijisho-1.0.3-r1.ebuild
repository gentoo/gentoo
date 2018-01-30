# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils gnome2-utils

DESCRIPTION="Open-source Japanese dictionary and kanji lookup tool"
HOMEPAGE="http://www.tagaini.net/"
SRC_URI="https://github.com/Gnurou/tagainijisho/releases/download/${PV}/${P}.tar.gz"
LICENSE="GPL-3+ public-domain"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	>=dev-db/sqlite-3.11:3"
RDEPEND="${DEPEND}"

pkg_langs=( ar cs de es fa fi fr hu id it nb nl pl pt ru sv th tr vi )
IUSE+=" ${pkg_langs[@]/#/l10n_}"

PATCHES=( "${FILESDIR}"/${P}-sqlite.patch )

src_configure() {
	# GUI linguae
	# en is not optional, and build fails if none other then en is set, so adding ja as non-optional too
	# linguae undeclared in IUSE will trigger an error, which is a handy check
	local lang use_lang
	for lang in i18n/*.ts; do
		lang=${lang#i18n/tagainijisho_}
		lang=${lang%.ts}
		case ${lang} in
			fa_IR|fi_FI) use_lang=${lang%%_*} ;; # use generic tags instead
			*) use_lang=${lang} ;;
		esac
		if [[ ${lang} != en && ${lang} != ja ]] && ! use l10n_${use_lang}; then
			rm i18n/tagainijisho_${lang}.ts || die
		fi
	done

	# Dictionary linguae
	# en is not optional here either, but nothing special needs to be done
	# here too, linguae undeclared in IUSE will trigger an error
	local cmake_langs
	for lang in $(sed -e 's/;/ /g' -ne '/set(DICT_LANG ".*")/s/.*"\(.*\)".*/\1/p' CMakeLists.txt); do
		if use l10n_${lang}; then
			cmake_langs+=";${lang}"
		fi
	done
	mycmakeargs=( -DDICT_LANG="${cmake_langs};" )

	cmake-utils_src_configure
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
