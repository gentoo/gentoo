# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fdo-mime gnome2-utils

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://gmusicbrowser.org/"
SRC_URI="http://${PN}.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus doc extras gstreamer libnotify mplayer"

GSTREAMER_DEPEND="dev-perl/Glib-Object-Introspection"
MPLAYER_DEPEND="media-video/mplayer"
MPV_DEPEND="media-video/mpv"
OTHER_DEPEND="
	media-sound/alsa-utils
	media-sound/flac123
	|| ( media-sound/mpg123 media-sound/mpg321 )
	media-sound/vorbis-tools"

RDEPEND="dev-lang/perl
	dev-perl/Gtk2
	virtual/perl-MIME-Base64
	|| ( net-misc/wget dev-perl/AnyEvent-HTTP )
	dbus? ( dev-perl/Net-DBus )
	gstreamer? ( ${GSTREAMER_DEPEND} )
	mplayer? ( || ( ${MPLAYER_DEPEND} ${MPV_DEPEND} ) )
	!gstreamer? ( !mplayer? ( ${OTHER_DEPEND} ) )
	extras? ( dev-perl/gnome2-wnck )
	libnotify? ( dev-perl/Gtk2-Notify )"
DEPEND="sys-devel/gettext"

src_install() {
	emake \
		DESTDIR="${D}" \
		iconsdir="${D%/}/usr/share/icons/hicolor" \
		install

	use doc && local HTML_DOCS=( layout_doc.html )
	einstalldocs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	elog "Gmusicbrowser supports gstreamer, mplayer, mpv and mpg123/ogg123..."
	elog "for audio playback. Needed dependencies:"
	elog "  Gstreamer: ${GSTREAMER_DEPEND}"
	elog "  mplayer: ${MPLAYER_DEPEND}"
	elog "  mpv: ${MPV_DEPEND}"
	elog "  mpg123/ogg123...: ${OTHER_DEPEND}"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
