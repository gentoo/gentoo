# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WANT_LIBTOOL=none
inherit cmake-utils gnome2-utils git-r3

DESCRIPTION="Volume mixer for the system tray"
HOMEPAGE="https://github.com/nicklan/pnmixer"
EGIT_REPO_URI="git@github.com:nicklan/pnmixer.git
	https://github.com/nicklan/pnmixer.git"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="libnotify"

RDEPEND="dev-libs/glib:2
	media-libs/alsa-lib
	>=x11-libs/gtk+-3.12:3
	x11-libs/libX11
	libnotify? ( x11-libs/libnotify )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DWITH_LIBNOTIFY="$(usex libnotify)"
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
