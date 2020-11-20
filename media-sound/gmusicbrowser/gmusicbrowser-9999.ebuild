# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 gnome2-utils xdg

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="https://gmusicbrowser.org/"
EGIT_REPO_URI="https://github.com/squentin/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus doc extras gstreamer libnotify mplayer"

RDEPEND="dev-lang/perl
	dev-perl/Gtk3
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
DEPEND="sys-devel/gettext
	doc? ( dev-perl/Text-Markdown )"

src_compile() {
	emake MARKDOWN=$(usex doc "Markdown.pl" "echo")
}

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
