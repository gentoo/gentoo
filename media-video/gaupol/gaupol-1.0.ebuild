# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )

inherit distutils-r1 gnome2-utils virtualx xdg-utils

DESCRIPTION="A subtitle editor for text-based subtitles"
HOMEPAGE="http://otsaloma.io/gaupol/"
SRC_URI="https://github.com/otsaloma/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell test"

RDEPEND="app-text/iso-codes
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	spell? (
		app-text/gtkspell:3
		>=dev-python/pyenchant-1.4[${PYTHON_USEDEP}]
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

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Previewing support needs MPV, MPlayer or VLC."

		if use spell; then
			elog "Additionally, spell-checking requires a dictionary, any of"
			elog "Aspell/Pspell, Ispell, MySpell, Uspell, Hspell or AppleSpell."
		fi
	fi
}

python_test() {
	virtx py.test
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
