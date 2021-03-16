# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils xdg

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="https://gmusicbrowser.org/"
SRC_URI="https://${PN}.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc extras gstreamer libnotify mplayer"

RDEPEND="dev-lang/perl
	dev-perl/Gtk2
	virtual/perl-MIME-Base64
	|| ( net-misc/wget dev-perl/AnyEvent-HTTP )
	dbus? ( dev-perl/Net-DBus )
	gstreamer? ( dev-perl/Glib-Object-Introspection )
	mplayer? ( || ( media-video/mplayer media-video/mpv ) )
	!gstreamer? ( !mplayer? (
			media-sound/alsa-utils
			media-sound/flac123
			|| ( media-sound/mpg123 media-sound/mpg321 )
			media-sound/vorbis-tools
		)
	)
	extras? ( dev-perl/gnome2-wnck )
	libnotify? ( dev-perl/Gtk2-Notify )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# silence QA warnings
	sed -i '/^OnlyShowIn/d' gmusicbrowser.desktop || die
}

src_install() {
	emake \
		DESTDIR="${D}" \
		iconsdir="${D}/usr/share/icons/hicolor" \
		install

	use doc && local HTML_DOCS=( layout_doc.html )
	einstalldocs
}
