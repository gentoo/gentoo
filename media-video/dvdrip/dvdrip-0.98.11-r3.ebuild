# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic perl-module

DESCRIPTION="dvd::rip is a graphical frontend for transcode"
HOMEPAGE="http://www.exit1.org/dvdrip/"
SRC_URI="http://www.exit1.org/dvdrip/dist/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="ffmpeg fping mplayer ogg subtitles vcd vorbis xine xvid"

DEPEND=">=dev-perl/Event-ExecFlow-0.64
	>=dev-perl/Event-RPC-0.89
	dev-perl/Gtk2
	>=dev-perl/gtk2-ex-formfactory-0.65
	>=dev-perl/libintl-perl-1.16
	>=media-video/transcode-1.1.0[dvd,jpeg,mp3,ogg,vorbis]
	virtual/imagemagick-tools
	>=virtual/perl-podlators-2.5.3
"
RDEPEND="${DEPEND}
	x11-libs/gdk-pixbuf:2[jpeg]
	x11-libs/gtk+:2
	ffmpeg? ( virtual/ffmpeg )
	fping? ( >=net-analyzer/fping-2.2 )
	mplayer? ( media-video/mplayer )
	ogg? ( media-sound/ogmtools )
	subtitles? ( media-video/subtitleripper )
	vcd? (
		media-video/transcode[mjpeg]
		>=media-video/mjpegtools-1.6.0
	)
	vorbis? ( media-sound/vorbis-tools )
	xine? ( media-video/xine-ui )
	xvid? ( media-video/xvid4conf )
	>=media-video/lsdvd-0.15"

pkg_setup() {
	filter-flags -ftracer
	export SKIP_UNPACK_REQUIRED_MODULES=1 #255269

	perl_set_version
}

src_prepare() {
	sed -i -e 's:$(CC):$(CC) $(OTHERLDFLAGS):' src/Makefile || die #333739
	epatch "${FILESDIR}"/${P}-fix_parallel_make.patch
	# Fix default device for >=udev-180 wrt #224559
	sed -i -e 's:/dev/dvd:/dev/cdrom:' lib/Video/DVDRip/Config.pm || die
}

src_install() {
	newicon lib/Video/DVDRip/icon.xpm dvdrip.xpm
	make_desktop_entry dvdrip dvd::rip

	mydoc="Changes* Credits README TODO" perl-module_src_install
}

pkg_postinst() {
	# bug 173924
	if use fping; then
		ewarn "For dvdrip-master to work correctly with cluster mode,"
		ewarn "the fping binary must be setuid."
		ewarn ""
		ewarn "Run this command to fix it:"
		ewarn "chmod u=rwsx,g=rx,o=rx /usr/sbin/fping"
		ewarn ""
		ewarn "Note that this is a security risk when enabled."
	fi
}
