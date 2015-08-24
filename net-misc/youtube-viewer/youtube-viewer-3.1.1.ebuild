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
KEYWORDS="amd64 x86"
IUSE="gtk"

RDEPEND="
	>=dev-lang/perl-5.16.0
	dev-perl/Data-Dump
	dev-perl/libwww-perl
	|| ( media-video/mplayer[X,network]
		media-video/mplayer2[X,network]
		media-video/mpv[X] )
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Term-ANSIColor
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

S=${WORKDIR}/${P}/WWW-YoutubeViewer

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
	einfo
	elog "optional dependencies:"
	elog "  dev-perl/LWP-Protocol-https or dev-perl/libwww-perl[ssl]"
	elog "  and virtual/perl-MIME-Base64"
	elog "    (for HTTPS protocol and login support)"
	elog "  dev-perl/Term-ReadLine-Gnu (for a better STDIN support)"
	elog "  dev-perl/Text-CharWidth (print the results in a fixed-width"
	elog "    format (--fixed-width, -W))"
	elog "  dev-perl/XML-Fast (faster XML to HASH conversion)"
	elog "  net-misc/gcap (for retrieving Youtube closed captions)"
	elog "  virtual/perl-File-Temp (for posting comments)"
	elog "  virtual/perl-Scalar-List-Utils (to shuffle the playlists"
	elog "    (--shuffle, -s))"
	elog "  virtual/perl-threads (threads support)"
	einfo
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
