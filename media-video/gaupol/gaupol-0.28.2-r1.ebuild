# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4,3_5} )

inherit distutils-r1 fdo-mime gnome2-utils versionator virtualx

MAJOR_MINOR_VERSION="$(get_version_component_range 1-2)"

DESCRIPTION="A subtitle editor for text-based subtitles"
HOMEPAGE="http://otsaloma.io/gaupol/"
SRC_URI="http://download.gna.org/${PN}/${MAJOR_MINOR_VERSION}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell test"

RDEPEND="app-text/iso-codes
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	spell? (
		>=dev-python/pyenchant-1.4[${PYTHON_USEDEP}]
		app-text/gtkspell:3
	)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.md NEWS.md TODO.md README.md README.aeidon.md )

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	elog "Previewing support needs MPlayer or VLC."

	if use spell; then
		elog "Additionally, spell-checking requires a dictionary, any of"
		elog "Aspell/Pspell, Ispell, MySpell, Uspell, Hspell or AppleSpell."
	fi
}

python_test() {
	virtx py.test
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
