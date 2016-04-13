# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Online command-line translator"
HOMEPAGE="https://www.soimort.org/translate-shell/"
SRC_URI="https://github.com/soimort/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+curl fribidi test tts"

RDEPEND="
	app-misc/rlwrap
	>=sys-apps/gawk-4.0.2
	curl? ( net-misc/curl[ssl] )
	fribidi? ( dev-libs/fribidi )
	tts? ( || (
		media-sound/mpg123
		app-accessibility/espeak
		media-video/mpv
		media-video/mplayer
		)
	)"
DEPEND="${RDEPEND}
	test? ( app-editors/emacs )
	"

src_install() {
	emake PREFIX="${D}/usr" install
}
