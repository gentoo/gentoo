# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune udev

DESCRIPTION="Kino is a non-linear DV editor for GNU/Linux"
HOMEPAGE="http://www.kinodv.org/"
SRC_URI="mirror://sourceforge/kino/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="alsa dvdr gpac lame libav quicktime sox vorbis"

# Optional dependency on cinelerra-cvs (as a replacement for libquicktime)
# dropped because kino may run with it but won't build anymore.

CDEPEND="
	>=x11-libs/gtk+-2.6.0:2
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
	media-libs/libv4l:0=
	alsa? ( >=media-libs/alsa-lib-1.0.9 )
	!libav? ( >=media-video/ffmpeg-3:0= )
	libav? ( media-video/libav:0= )
	quicktime? ( >=media-libs/libquicktime-0.9.5 )
"
DEPEND="${CDEPEND}
	dev-util/intltool
"
RDEPEND="${CDEPEND}
	media-video/mjpegtools
	media-sound/rawrec
	dvdr? ( media-video/dvdauthor
		app-cdr/dvd+rw-tools )
	gpac? ( media-video/gpac )
	lame? ( media-sound/lame )
	sox? ( media-sound/sox )
	vorbis? ( media-sound/vorbis-tools )
"

src_prepare() {
	default

	# Deactivating automagic alsa configuration, bug #134725
	if ! use alsa ; then
		sed -i -e "s:HAVE_ALSA 1:HAVE_ALSA 0:" configure || die
	fi

	# Fix bug #169590
	sed -i \
		-e '/\$(LIBQUICKTIME_LIBS) \\/d' \
		-e '/^[[:space:]]*\$(SRC_LIBS)/ a\
	\$(LIBQUICKTIME_LIBS) \\' \
		src/Makefile.in || die

	# Fix test failure discovered in bug #193947
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
	eapply "${FILESDIR}/${P}-v4l1.patch"
	eapply "${FILESDIR}/${P}-libav-0.7.patch"
	eapply "${FILESDIR}/${P}-libav-0.8.patch"
	eapply "${FILESDIR}/${P}-libavcodec-pkg-config.patch"
	eapply "${FILESDIR}/${P}-ffmpeg3.patch"

	mv configure.in configure.ac || die
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
