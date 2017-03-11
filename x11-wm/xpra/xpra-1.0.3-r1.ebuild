# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# PyCObject_Check and PyCObject_AsVoidPtr vanished with python 3.3, and setup.py not python3.2 compat
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 eutils flag-o-matic user tmpfiles

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy"
HOMEPAGE="http://xpra.org/ http://xpra.org/src/"
SRC_URI="http://xpra.org/src/${P}.tar.xz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="+client +clipboard csc cups dec_av2 enc_ffmpeg libav +lz4 lzo opengl pulseaudio server sound vpx webcam webp x264 x265"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	clipboard? ( || ( server client ) )
	opengl? ( client )
	|| ( client server )
	client? ( x264? ( dec_av2 ) x265? ( dec_av2 ) )"

# x264/old-libav.path situation see bug 459218
COMMON_DEPEND=""${PYTHON_DEPS}"
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	csc? (
		!libav? ( >=media-video/ffmpeg-1.2.2:0= )
		libav? ( media-video/libav:0= )
	)
	dec_av2? (
		!libav? ( >=media-video/ffmpeg-2:0= )
		libav? ( media-video/libav:0= )
	)
	enc_ffmpeg? (
		!libav? ( >=media-video/ffmpeg-3.2.2:0= )
		libav? ( media-video/libav:0= )
	)
	opengl? ( dev-python/pygtkglext )
	pulseaudio? ( media-sound/pulseaudio )
	sound? ( media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		dev-python/gst-python:1.0 )
	vpx? ( media-libs/libvpx virtual/ffmpeg )
	webp? ( media-libs/libwebp )
	x264? ( media-libs/x264
		!libav? ( >=media-video/ffmpeg-1.0.4:0= )
		libav? ( media-video/libav:0= )
	)
	x265? ( media-libs/x265
		!libav? ( >=media-video/ffmpeg-2:0= )
		libav? ( media-video/libav:0= )
	)"

RDEPEND="${COMMON_DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/rencode[${PYTHON_USEDEP}]
	virtual/ssh
	x11-apps/xmodmap
	cups? ( dev-python/pycups[${PYTHON_USEDEP}] )
	lz4? ( dev-python/lz4[${PYTHON_USEDEP}] )
	lzo? ( >=dev-python/python-lzo-0.7.0[${PYTHON_USEDEP}] )
	opengl? (
		client? ( dev-python/pyopengl_accelerate[${PYTHON_USEDEP}] )
	)
	server? ( x11-base/xorg-server[-minimal,xvfb]
		x11-drivers/xf86-input-void
		x11-drivers/xf86-video-dummy
	)
	webcam? ( media-libs/opencv[python]
		dev-python/pyinotify[${PYTHON_USEDEP}] )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=dev-python/cython-0.16[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.13.1-ignore-gentoo-no-compile.patch
	"${FILESDIR}"/${PN}-0.17.4-deprecated-avcodec.patch )

pkg_postinst() {
	enewgroup ${PN}
	tmpfiles_process /usr/lib/tmpfiles.d/xpra.conf
}

python_prepare_all() {
	rm -rf rencode || die

	sed -e "s:/var/run/xpra:${EROOT}run/xpra:" \
		-i tmpfiles.d/xpra.conf

	if use libav ; then
		if ! has_version ">=media-video/libav-9" ; then
			epatch patches/old-libav.patch
		fi
	fi

	if ! use pulseaudio ; then #bug 608126
		sed -e '/pulseaudio/s:bstr(not OSX and not WIN32):bstr(False):' \
			-i setup.py || die
	fi

	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=(
		$(use_with client)
		$(use_with clipboard)
		$(use_with csc csc_swscale)
		$(use_with cups printing)
		$(use_with dec_av2 dec_avcodec2)
		$(use_with enc_ffmpeg)
		$(use_with opengl)
		$(use_with server shadow)
		$(use_with server)
		$(use_with sound)
		$(use_with vpx)
		$(use_with webp)
		$(use_with x264 enc_x264)
		$(use_with x265 enc_x265)
		$(use_with webcam)
		--with-Xdummy
		--with-gtk2
		--without-gtk3
		--with-strict
		--with-warn
		--with-x11
		--without-PIC
		--without-debug )

	# see https://www.xpra.org/trac/ticket/1080
	# and http://trac.cython.org/ticket/395
	append-cflags -fno-strict-aliasing

	export XPRA_SOCKET_DIRS="${EROOT}run/xpra"
}
