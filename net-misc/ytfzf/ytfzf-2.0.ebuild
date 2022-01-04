# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Posix script to find and watch youtube videos from the terminal"
HOMEPAGE="https://github.com/pystardust/ytfzf/"
SRC_URI="https://github.com/pystardust/ytfzf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

# fzf/mpv/yt-dlp "can" be optfeatures depending on configuration, but depend
# on them so it works as expected out-of-the-box while allowing to disable.
RDEPEND="
	app-misc/jq
	net-misc/curl[ssl]
	!minimal? (
		app-shells/fzf
		media-video/mpv[lua]
		net-misc/yt-dlp
	)"

src_compile() { :; }

src_install() {
	dobin ytfzf
	doman docs/man/${PN}.{1,5}
	dodoc README.md docs/conf.sh
}

pkg_postinst() {
	optfeature "external menu support" x11-misc/dmenu
	optfeature "in-terminal thumbnails on X11" media-gfx/ueberzug
	optfeature "in-terminal thumbnails on wayland" media-gfx/chafa
	optfeature "desktop notifications" x11-libs/libnotify

	if [[ ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 2.0; then
		elog "Note that >=${PN}-2.0 is a major rewrite and is not compatible with"
		elog "configuration and some command arguments of older versions, see the"
		elog "newly added ${PN}(1) and ${PN}(5) man pages for more information."
	fi
}
