# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

pkg_linguas=( ar cs de es fi_FI fr it nb nl pt ru sv th tr vi )
IUSE+=" ${pkg_linguas[@]/#/linguas_}"

src_configure() {
	# GUI linguas
	# en is not optional, and build fails if none other then en is set, so adding ja as non-optional too
	# linguas undeclared in IUSE will trigger an error, which is a handy check
	for lingua in $(ls -1 i18n/*.ts | sed -e 's/.*tagainijisho_\(.*\)\.ts/\1/' | grep -v en | grep -v ja); do
		if ! use linguas_${lingua}; then
			rm i18n/tagainijisho_${lingua}.ts || die
		fi
	done

	# Dictionary linguas
	# en is not optional here either, but nothing special needs to be done
	# here too, linguas undeclared in IUSE will trigger an error
	local cmake_linguas
	for lingua in $(sed -e 's/;/ /g' -ne '/set(DICT_LANG ".*")/s/.*"\(.*\)".*/\1/p' CMakeLists.txt); do
		if use linguas_${lingua}; then
			cmake_linguas+=";${lingua}"
		fi
	done
	mycmakeargs=( -DDICT_LANG="${cmake_linguas};" )

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
