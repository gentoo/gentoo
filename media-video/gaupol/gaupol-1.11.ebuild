# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 virtualx xdg-utils

DESCRIPTION="A subtitle editor for text-based subtitles"
HOMEPAGE="https://otsaloma.io/gaupol/"
SRC_URI="https://github.com/otsaloma/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="spell"

RDEPEND="
	app-text/iso-codes
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	spell? ( app-text/gspell[introspection] )
"
BDEPEND="
	sys-devel/gettext
	test? (
		app-dicts/myspell-en
		app-text/enchant[hunspell]
		app-text/gspell[introspection]
	)
"

distutils_enable_tests pytest

DOCS=( AUTHORS.md NEWS.md README.md README.aeidon.md )

python_test() {
	virtx epytest
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The integrated video player requires media-plugins/gst-plugins-gtk."
		elog ""
		elog "External video previewing support requires MPV, MPlayer or VLC."
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
