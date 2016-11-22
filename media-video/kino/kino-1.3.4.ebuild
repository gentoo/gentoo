# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils udev

DESCRIPTION="Kino is a non-linear DV editor for GNU/Linux"
HOMEPAGE="http://www.kinodv.org/"
SRC_URI="mirror://sourceforge/kino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="alsa dvdr gpac lame gstreamer quicktime sox vorbis"

# This ebuild would benefit a lot of USE dependencies but that has to wait for
# EAPI 2. The usual fix is to issue built_with_use checks but in that particu-
# lar case it would make the ebuild rather complicated to write and maintain
# (certain features can be enabled in various different ways). Also it would
# also force the emerge process to stop a bit too often for users not to comp-
# lain. Thus, if you need features like theora, x264, xvid and maybe others,
# make sure you activate the required support where it should be (ffmpeg, mostly).

# Optional dependency on cinelerra-cvs (as a replacement for libquicktime)
# dropped because kino may run with it but won't build anymore.

CDEPEND=">=x11-libs/gtk+-2.6.0:2
	>=gnome-base/libglade-2.5.0
	>=dev-libs/glib-2:2
	x11-libs/libXv
	dev-libs/libxml2:2
	media-libs/audiofile
	>=sys-libs/libraw1394-1.0.0
	>=sys-libs/libavc1394-0.4.1
	>=media-libs/libdv-0.103
	media-libs/libsamplerate
	media-libs/libiec61883
	media-libs/libv4l
	alsa? ( >=media-libs/alsa-lib-1.0.9 )
	virtual/ffmpeg
	quicktime? ( >=media-libs/libquicktime-0.9.5 )"
DEPEND="${CDEPEND}
	dev-util/intltool"
RDEPEND="${CDEPEND}
	media-video/mjpegtools
	media-sound/rawrec
	dvdr? ( media-video/dvdauthor
		app-cdr/dvd+rw-tools )
	gpac? ( media-video/gpac )
	lame? ( media-sound/lame )
	gstreamer? ( media-libs/gst-plugins-base:0.10 )
	sox? ( media-sound/sox )
	vorbis? ( media-sound/vorbis-tools )"

DOCS="AUTHORS BUGS ChangeLog NEWS README* TODO"

src_prepare() {
	# Deactivating automagic alsa configuration, bug #134725
	if ! use alsa ; then
		sed -i -e "s:HAVE_ALSA 1:HAVE_ALSA 0:" configure || die
	fi

	# Fix bug #169590
	# https://sourceforge.net/tracker/?func=detail&aid=3304495&group_id=14103&atid=314103
	sed -i \
		-e '/\$(LIBQUICKTIME_LIBS) \\/d' \
		-e '/^[[:space:]]*\$(SRC_LIBS)/ a\
	\$(LIBQUICKTIME_LIBS) \\' \
		src/Makefile.in || die

	# Fix test failure discovered in bug #193947
	# https://sourceforge.net/tracker/?func=detail&aid=3304499&group_id=14103&atid=314103
	sed -i -e '$a\
\
ffmpeg/libavcodec/ps2/idct_mmi.c\
ffmpeg/libavcodec/sparc/dsputil_vis.c\
ffmpeg/libavcodec/sparc/vis.h\
ffmpeg/libavutil/bswap.h\
ffmpeg/libswscale/yuv2rgb_template.c\
src/export.h\
src/message.cc\
src/page_bttv.cc' po/POTFILES.in || die

	sed -i -e 's:^#include <quicktime.h>:#include <lqt/quicktime.h>:' src/filehandler.h || die
	epatch "${FILESDIR}/${P}-v4l1.patch"
	epatch "${FILESDIR}/${P}-libav-0.7.patch"
	epatch "${FILESDIR}/${P}-libav-0.8.patch"
	epatch "${FILESDIR}/${P}-libavcodec-pkg-config.patch"

	eautoreconf
}

src_configure() {
	econf \
		--disable-local-ffmpeg \
		$(use_enable quicktime) \
		$(use_with sparc dv1394) \
		--with-udev-rules-dir="$(get_udevdir)"/rules.d \
		CPPFLAGS="-I${ROOT}usr/include/libavcodec -I${ROOT}usr/include/libavformat -I${ROOT}usr/include/libswscale"
}

src_install() {
	default
	mv "${ED}/$(get_udevdir)"/rules.d/{,99-}kino.rules
	fowners root:root -R /usr/share/kino/help #177378
	prune_libtool_files --all #385361
}
