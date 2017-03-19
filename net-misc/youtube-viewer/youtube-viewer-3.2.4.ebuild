# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils perl-module

DESCRIPTION="A command line utility for viewing youtube-videos in Mplayer"
HOMEPAGE="https://trizenx.blogspot.com/2012/03/gtk-youtube-viewer.html"
SRC_URI="https://github.com/trizen/youtube-viewer/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="
	dev-perl/Data-Dump
	dev-perl/JSON
	dev-perl/libwww-perl[ssl]
	dev-perl/Term-ReadLine-Gnu
	virtual/perl-Encode
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Scalar-List-Utils
	virtual/perl-Term-ANSIColor
	virtual/perl-Term-ReadLine
	virtual/perl-Text-ParseWords
	virtual/perl-Text-Tabs+Wrap
	gtk? (
		dev-perl/File-ShareDir
		>=dev-perl/Gtk2-1.244.0
		virtual/freedesktop-icon-theme
		x11-libs/gdk-pixbuf:2[X,jpeg]
	)"
DEPEND="dev-perl/Module-Build"

SRC_TEST="do"

src_prepare() {
	perl-module_src_prepare
}

# build system installs files on "perl Build.PL" too
# do all the work in src_install
src_configure() { :; }
src_compile() { :; }

src_install() {
	local myconf
	if use gtk ; then
		myconf="--gtk-youtube-viewer"
	fi
	perl-module_src_configure
	perl-module_src_install

	if use gtk ; then
		domenu share/gtk-youtube-viewer.desktop
		doicon share/icons/gtk-youtube-viewer.png
	fi
}

pkg_preinst() {
	use gtk && gnome2_icon_savelist
	perl_set_version
}

pkg_postinst() {
	use gtk && gnome2_icon_cache_update
	elog "Optional dependencies:"
	optfeature "cache support" dev-perl/LWP-UserAgent-Cached
	optfeature "better STDIN support" dev-perl/Term-ReadLine-Gnu
	optfeature "faster JSON to HASH conversion" dev-perl/JSON-XS
	optfeature "the case if there are SSL problems" dev-perl/Mozilla-CA
	optfeature "printing results in a fixed-width format (--fixed-width, -W)" dev-perl/Text-CharWidth
	optfeature "threads support" virtual/perl-threads
	elog
	elog "You also need a compatible video player, possible choices are:"
	elog "  media-video/mpv"
	elog "  media-video/mplayer"
	elog "  media-video/smplayer"
	elog "  media-video/vlc"
	elog "Also check the configuration file in ~/.config/youtube-viewer/"
	elog "and configure your video player backend."
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
