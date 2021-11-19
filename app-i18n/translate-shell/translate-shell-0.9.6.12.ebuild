# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="Online command-line translator"
HOMEPAGE="https://www.soimort.org/translate-shell/"
SRC_URI="https://github.com/soimort/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-apps/gawk"
DEPEND="${RDEPEND}
	test? (
		app-editors/emacs
		app-misc/rlwrap
	)"

src_test() {
	emake NETWORK_ACCESS=no test
}

src_install() {
	emake PREFIX="${D}/usr" install
}

pkg_postinst() {
	optfeature "all built-in translators (e.g. Apertium, Yandex)" net-misc/curl[ssl]
	optfeature "display text in right-to-left scripts" dev-libs/fribidi
	optfeature "text-to-speech functionality" media-sound/mpg123 app-accessibility/espeak media-video/mpv media-video/mplayer
	optfeature "interactive translation (REPL)" app-editors/emacs app-misc/rlwrap
	optfeature "spell checking" app-text/aspell app-text/hunspell
}
