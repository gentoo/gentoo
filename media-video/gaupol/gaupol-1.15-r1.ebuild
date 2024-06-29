# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature virtualx xdg-utils

DESCRIPTION="A subtitle editor for text-based subtitles"
HOMEPAGE="https://otsaloma.io/gaupol/"
SRC_URI="https://github.com/otsaloma/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	app-text/iso-codes
	dev-python/charset-normalizer[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
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

PATCHES=(
	"${FILESDIR}/${PN}-1.12-fix-prefix.patch"
)

python_test() {
	virtx epytest
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "Spellchecking with myspell* dictionaries" \
			   "app-text/gspell[introspection] app-text/enchant[aspell]" \
			   "app-text/gspell[introspection] app-text/enchant[hunspell]" \
			   "app-text/gspell[introspection] app-text/enchant[nuspell]"

	optfeature "external player" media-video/mplayer media-video/mpv media-video/vlc
	# optfeature "internal player support" TODO(setan): add this
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
