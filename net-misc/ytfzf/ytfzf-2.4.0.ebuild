# Copyright 2021-2022 Gentoo Authors
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
	virtual/awk
	!minimal? (
		app-shells/fzf
		media-video/mpv[lua]
		net-misc/yt-dlp
	)"

src_prepare() {
	default

	sed -i "/^: ...YTFZF_SYSTEM_ADDON_DIR/s|/usr/local|${EPREFIX}/usr|" ytfzf || die
}

src_compile() { :; }

src_install() {
	local emakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
	)

	emake "${emakeargs[@]}" addons doc install
	einstalldocs

	rm -r "${ED}"/usr/share/licenses || die
}

pkg_postinst() {
	optfeature "external menu support" x11-misc/dmenu
	optfeature "in-terminal thumbnails on X11" media-gfx/ueberzug
	optfeature "desktop notifications" x11-libs/libnotify

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that ${PN} supports many methods to display menus/thumbnails."
		elog "This ebuild primarily covers defaults and major features, additional"
		elog "dependencies may be needed for others."
	fi
}
