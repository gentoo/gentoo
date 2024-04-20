# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Posix script to find and watch youtube videos from the terminal"
HOMEPAGE="https://github.com/pystardust/ytfzf/"
SRC_URI="https://github.com/pystardust/ytfzf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal +thumbnails"

RDEPEND="
	app-misc/jq
	net-misc/curl[ssl]
	app-alternatives/awk
	!minimal? (
		app-shells/fzf
		media-video/mpv[lua]
		net-misc/yt-dlp
		thumbnails? (
			|| (
				media-gfx/ueberzugpp
				media-gfx/ueberzug
			)
		)
	)
"

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
	optfeature "desktop notifications" x11-libs/libnotify

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that ${PN} supports many methods to display menus/thumbnails."
		elog "This ebuild primarily covers defaults and major features, additional"
		elog "dependencies may be needed for others. Set USE=minimal if want full"
		elog "control over optional dependencies (e.g. fzf is optional if use dmenu)."
	fi
}
