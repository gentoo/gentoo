# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# PyCObject_Check and PyCObject_AsVoidPtr vanished with python 3.3
PYTHON_COMPAT=( python2_7 )
inherit xdg distutils-r1 eutils flag-o-matic user tmpfiles prefix

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy"
HOMEPAGE="http://xpra.org/ http://xpra.org/src/"
SRC_URI="http://xpra.org/src/${P}.tar.xz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+client +clipboard csc cups dbus dec_avcodec2 enc_ffmpeg enc_x264 enc_x265 jpeg libav +lz4 lzo opengl pillow pulseaudio server sound test vpx webcam webp"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	clipboard? ( || ( server client ) )
	cups? ( dbus )
	opengl? ( client )
	|| ( client server )
	client? ( enc_x264? ( dec_avcodec2 ) enc_x265? ( dec_avcodec2 ) )"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libxkbfile
	csc? (
		!libav? ( >=media-video/ffmpeg-1.2.2:0= )
		libav? ( media-video/libav:0= )
	)
	dec_avcodec2? (
		!libav? ( >=media-video/ffmpeg-2:0= )
		libav? ( media-video/libav:0= )
	)
	enc_ffmpeg? (
		!libav? ( >=media-video/ffmpeg-3.2.2:0= )
		libav? ( media-video/libav:0= )
	)
	enc_x264? ( media-libs/x264
		!libav? ( >=media-video/ffmpeg-1.0.4:0= )
		libav? ( media-video/libav:0= )
	)
	enc_x265? ( media-libs/x265
		!libav? ( >=media-video/ffmpeg-2:0= )
		libav? ( media-video/libav:0= ) )
	jpeg? ( media-libs/libjpeg-turbo )
	opengl? ( dev-python/pygtkglext )
	pulseaudio? ( media-sound/pulseaudio )
	sound? ( media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		dev-python/gst-python:1.0 )
	vpx? ( media-libs/libvpx virtual/ffmpeg )
	webp? ( media-libs/libwebp )"

RDEPEND="${COMMON_DEPEND}
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/rencode[${PYTHON_USEDEP}]
	virtual/ssh
	x11-apps/xmodmap
	cups? ( dev-python/pycups[${PYTHON_USEDEP}] )
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	lz4? ( dev-python/lz4[${PYTHON_USEDEP}] )
	lzo? ( >=dev-python/python-lzo-0.7.0[${PYTHON_USEDEP}] )
	opengl? (
		client? ( dev-python/pyopengl_accelerate[${PYTHON_USEDEP}] )
	)
	pillow? ( dev-python/pillow[${PYTHON_USEDEP}] )
	server? ( x11-base/xorg-server[-minimal,xvfb]
		x11-drivers/xf86-input-void
	)
	webcam? ( dev-python/numpy[${PYTHON_USEDEP}]
		media-libs/opencv[python]
		dev-python/pyinotify[${PYTHON_USEDEP}] )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=dev-python/cython-0.16[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.13.1-ignore-gentoo-no-compile.patch
	"${FILESDIR}"/${PN}-2.0-suid-warning.patch )

pkg_postinst() {
	enewgroup ${PN}
	tmpfiles_process /usr/lib/tmpfiles.d/xpra.conf

	xdg_pkg_postinst
}

python_prepare_all() {
	hprefixify -w '/os.path/' setup.py
	hprefixify tmpfiles.d/xpra.conf xpra/server/{server,socket}_util.py \
		xpra/platform{/xposix,}/paths.py xpra/scripts/server.py

	distutils-r1_python_prepare_all
}

python_configure_all() {
	sed -e "/'pulseaudio'/s:DEFAULT_PULSEAUDIO:$(usex pulseaudio True False):" \
		-i setup.py || die

	mydistutilsargs=(
		--without-PIC
		--without-Xdummy
		$(use_with client)
		$(use_with clipboard)
		$(use_with csc csc_swscale)
		--without-csc_libyuv
		$(use_with cups printing)
		--without-debug
		$(use_with dbus)
		$(use_with dec_avcodec2)
		$(use_with enc_ffmpeg)
		$(use_with enc_x264)
		$(use_with enc_x265)
		--with-gtk2
		--without-gtk3
		--without-html5
		$(use_with jpeg)
		--without-mdns
		--without-minify
		$(use_with opengl)
		$(use_with server shadow)
		$(use_with server)
		$(use_with sound)
		--with-strict
		$(use_with vpx)
		--with-warn
		$(use_with webcam)
		$(use_with webp)
		--with-x11
	)

	# see https://www.xpra.org/trac/ticket/1080
	# and http://trac.cython.org/ticket/395
	append-cflags -fno-strict-aliasing

	export XPRA_SOCKET_DIRS="${EPREFIX}/run/xpra"
}
