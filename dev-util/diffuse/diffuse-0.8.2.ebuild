# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
PLOCALES="cs de es fr it ja ka ko nl pl pt pt_BR ru sv th tr zh_CN zh_TW"
inherit meson plocale python-r1 xdg

DESCRIPTION="A graphical tool to compare and merge text files"
HOMEPAGE="http://diffuse.sourceforge.net/ https://github.com/MightyCreak/diffuse/"
SRC_URI="https://github.com/MightyCreak/diffuse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
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
	plocale_find_changes po '' '.po'

	rm_locale() {
		rm -f po/${1}.po
		rm -rf data/usr/share/man/${1}
		rm -rf data/usr/share/gnome/help/${PN}/$1
		rm -f data/usr/share/omf/${PN}/${PN}-$1.omf
		sed -e "/^${1}/d" -i po/LINGUAS
	}

	plocale_for_each_disabled_locale rm_locale
}

src_install() {
	meson_src_install
	rm "${D}"/usr/bin/${PN} || die "rm ${PN} failed"
	python_foreach_impl python_doscript ../${P}-build/src/${PN}/${PN}
	mkdir "${D}"/usr/share/metainfo || die "mkdir metainfo failed"
	mv "${D}"/usr/share/appdata/* "${D}"/usr/share/metainfo/ \
		|| die "mv appdata -> metainfo failed"
	dodoc AUTHORS CHANGELOG.md README.md
}
