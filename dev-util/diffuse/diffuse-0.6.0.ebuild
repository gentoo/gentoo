# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
PLOCALES="cs de es it ja ko pl pt ru sv th zh_CN zh_TW"
inherit meson plocale python-single-r1 xdg-utils

DESCRIPTION="A graphical tool to compare and merge text files"
HOMEPAGE="http://diffuse.sourceforge.net/ https://github.com/MightyCreak/diffuse/"
SRC_URI="https://github.com/MightyCreak/diffuse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
	')
	x11-libs/gtk+:3[introspection]"
# file collision, bug #279018
DEPEND="${DEPEND}
	!sci-chemistry/tinker"

src_prepare() {
	default
	plocale_find_changes translations '' '.po'

	rm_locale() {
		rm -f translations/${1}.po
		rm -rf src/usr/share/man/${1}
		rm -rf src/usr/share/gnome/help/${PN}/$1
		rm -f src/usr/share/omf/${PN}/${PN}-$1.omf
		sed -e "/^${1}/d" -i translations/LINGUAS
	}

	plocale_for_each_disabled_locale rm_locale
}

src_install() {
	meson_src_install
	dodoc AUTHORS CHANGELOG.md README.md
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
