# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
PLOCALES="cs de es it ja ko pl pt ru sv th zh_CN zh_TW"
inherit python-single-r1 l10n xdg-utils

DESCRIPTION="A graphical tool to compare and merge text files"
HOMEPAGE="http://diffuse.sourceforge.net/ https://github.com/MightyCreak/diffuse/"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
	x11-libs/gtk+:3[introspection]"
# file collision, bug #279018
DEPEND="${DEPEND}
	!sci-chemistry/tinker"

src_prepare() {
	default
	l10n_find_plocales_changes translations '' '.po'

	rm_locale() {
		rm -f translations/${1}.po
		rm -rf src/usr/share/man/${1}
		rm -rf src/usr/share/gnome/help/${PN}/$1
		rm -f src/usr/share/omf/${PN}/${PN}-$1.omf
	}

	l10n_for_each_disabled_locale_do rm_locale
}

src_install() {
	"${PYTHON}" install.py \
		--prefix="${EPREFIX}"/usr \
		--sysconfdir="${EPREFIX}"/etc \
		--files-only \
		--destdir="${D}" \
		|| die "Installation failed"
	dodoc AUTHORS ChangeLog README.md
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
