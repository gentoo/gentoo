# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 virtualx xdg-utils

DESCRIPTION="A subtitle editor for text-based subtitles"
HOMEPAGE="https://otsaloma.io/gaupol/"
SRC_URI="https://github.com/otsaloma/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="spell test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/iso-codes
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	spell? ( app-text/gspell[introspection] )
"
DEPEND="
	sys-devel/gettext
	test? (
		${RDEPEND}
		app-dicts/myspell-en
		app-text/enchant[hunspell]
		app-text/gspell[introspection]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.md NEWS.md TODO.md README.md README.aeidon.md )

PATCHES=( "${FILESDIR}/${P}-fix-tests.patch" )

python_test() {
	virtx pytest -vv
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Previewing support requires MPV, MPlayer or VLC."
		if use spell; then
			elog ""
			elog "Spell-checking requires a dictionary, any of app-dicts/myspell-*"
			elog "or app-text/aspell with the appropriate L10N variable."
			elog ""
			elog "Additionally, make sure that app-text/enchant has the correct flags enabled:"
			elog "USE=hunspell for myspell dictionaries and USE=aspell for aspell dictionaries."
		fi
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
