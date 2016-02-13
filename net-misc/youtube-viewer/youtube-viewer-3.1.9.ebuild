# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2-utils eutils perl-module vcs-snapshot

DESCRIPTION="A command line utility for viewing youtube-videos in Mplayer"
HOMEPAGE="https://trizen.googlecode.com"
SRC_URI="https://github.com/trizen/youtube-viewer/tarball/${PV} -> ${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="gtk"

RDEPEND="
	>=dev-lang/perl-5.16.0
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
		>=dev-perl/gtk2-perl-1.244.0
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
	elog
	elog "optional dependencies:"
	elog "  dev-perl/LWP-UserAgent-Cached (cache support)"
	elog "  dev-perl/Term-ReadLine-Gnu (for a better STDIN support)"
	elog "  dev-perl/JSON-XS (faster JSON to HASH conversion)"
	elog "  dev-perl/Mozilla-CA (just in case if there are SSL problems)"
	elog "  dev-perl/Text-CharWidth (print the results in a fixed-width"
	elog "    format (--fixed-width, -W))"
	elog "  virtual/perl-threads (threads support)"
	elog
	elog "You also need a compatible video player, possible choices are:"
	elog "  media-video/gnome-mplayer"
	elog "  media-video/mplayer[network]"
	elog "  media-video/mpv"
	elog "  media-video/smplayer"
	elog "  media-video/vlc"
	elog "Also check the configuration file in ~/.config/youtube-viewer/"
	elog "and configure your video player backend."
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
