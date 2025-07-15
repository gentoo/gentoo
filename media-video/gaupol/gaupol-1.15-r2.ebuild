# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature virtualx xdg-utils

DESCRIPTION="Editor for text-based subtitle files"
HOMEPAGE="https://otsaloma.io/gaupol/"
SRC_URI="https://github.com/otsaloma/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	app-text/iso-codes
	dev-python/charset-normalizer[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
BDEPEND="
	sys-devel/gettext
	test? (
		app-dicts/myspell-en
		app-text/gspell[introspection]
		|| (
			app-text/enchant[hunspell]
			>=app-text/enchant-2.2.8[nuspell]
		)
	)
"

DOCS=( {AUTHORS,NEWS,README{,.aeidon}}.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.12-fix-prefix.patch
)

distutils_enable_tests pytest

python_test() {
	virtx epytest
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	# To check which GStreamer plugins are required (vaapisink is mentioned in the code but it is not used):
	# plugins=$(qlist -e gaupol | xargs grep -ho 'Gst.ElementFactory.*' | cut -d'"' -f2 | sort -u | grep -vFx vaapisink)
	# xargs -n1 gst-inspect-1.0 <<< "$plugins" | awk '/Filename/ {print $2}' | sort -u | xargs qfile
	optfeature "built-in video player" \
		"media-libs/gstreamer[introspection] media-libs/gst-plugins-base[pango] media-plugins/gst-plugins-gtk"
	optfeature "external video player" media-video/mpv media-video/mplayer media-video/vlc

	optfeature "spellchecking (does not include dictionaries)" "app-text/gspell[introspection]"
	# To list dictionaries supported by gaupol:
	# python3 -c 'import aeidon; print(*aeidon.SpellChecker.list_languages(), sep="\n")'
	optfeature "spellchecking with app-dicts/myspell-* dictionaries using the nuspell backend" \
		"app-text/enchant[nuspell]"
	optfeature "spellchecking with app-dicts/myspell-* dictionaries using the hunspell backend" \
		"app-text/enchant[hunspell]"
	optfeature "spellchecking with app-dicts/aspell-* dictionaries" \
		"app-text/enchant[aspell]"

}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
