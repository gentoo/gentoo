# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils fdo-mime gnome2-utils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/squentin/gmusicbrowser.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	GIT_COMMIT="853840eb9dad0b59ad2dac5d303f5929b2f09f21"
	SRC_URI="https://github.com/squentin/gmusicbrowser/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
fi

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://gmusicbrowser.org/"

LICENSE="GPL-3"
SLOT="0"
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
DEPEND="sys-devel/gettext
	doc? ( dev-perl/Text-Markdown )"

src_compile() {
	emake MARKDOWN=$(usex doc "Markdown.pl" "echo")
}

src_install() {
	emake \
		DESTDIR="${D}" \
		iconsdir="${D%/}/usr/share/icons/hicolor" \
		install

	use doc && local HTML_DOCS=( layout_doc.html )
	einstalldocs
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
