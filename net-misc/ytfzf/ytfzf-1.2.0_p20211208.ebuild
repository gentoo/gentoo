# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

MY_COMMIT="dc7b0056e9b84cf786e6e4adda7f91564d1d012f"

DESCRIPTION="Posix script to find and watch youtube videos from the terminal"
HOMEPAGE="https://github.com/pystardust/ytfzf/"
SRC_URI="https://github.com/pystardust/ytfzf/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

# fzf/mpv "can" be optfeatures depending on configuration, but depend
# on them so it works as expected out-of-the-box and allow to disable.
RDEPEND="
	app-misc/jq
	net-misc/curl[ssl]
	net-misc/yt-dlp
	!minimal? (
		app-shells/fzf
		media-video/mpv[lua]
	)"

src_compile() { :; }

src_install() {
	dobin ytfzf

	dodoc README.md docs/{USAGE.md,conf.sh}
}

pkg_postinst() {
	optfeature "external menu support" x11-misc/dmenu x11-misc/rofi
	optfeature "in-terminal thumbnails on X11" \
		"media-gfx/ueberzug dev-python/pillow[jpeg]"
	optfeature "desktop notifications" x11-libs/libnotify
}
