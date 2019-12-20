# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Online command-line translator"
HOMEPAGE="https://www.soimort.org/translate-shell/"
SRC_URI="https://github.com/soimort/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bidi +curl test tts"
RESTRICT="!test? ( test )"

RDEPEND="
	app-misc/rlwrap
	=sys-apps/gawk-4*
	curl? ( net-misc/curl[ssl] )
	bidi? ( dev-libs/fribidi )
	tts? ( || (
		media-sound/mpg123
		app-accessibility/espeak
		media-video/mpv
		media-video/mplayer
		)
	)"
DEPEND="${RDEPEND}
	test? ( >=app-editors/emacs-23.1:* )
	"

src_test() {
	emake NETWORK_ACCESS=no test
}

src_install() {
	emake PREFIX="${D}/usr" install
}
