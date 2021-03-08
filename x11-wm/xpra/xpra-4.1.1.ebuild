# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_SETUPTOOLS=no
inherit xdg distutils-r1 tmpfiles prefix

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy"
HOMEPAGE="https://xpra.org/"
SRC_URI="https://xpra.org/src/${P}.tar.xz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="brotli +client +clipboard csc cups dbus doc ffmpeg jpeg +lz4 lzo minimal opengl pillow pulseaudio server sound test vpx webcam webp"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( client server )
	cups? ( dbus )
	opengl? ( client )
"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP},cairo]
		opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
		sound? ( dev-python/gst-python:1.0[${PYTHON_USEDEP}] )
	')
	x11-libs/gtk+:3[introspection]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libxkbfile
	brotli? ( app-arch/brotli )
	csc? ( >=media-video/ffmpeg-1.2.2:0= )
	ffmpeg? ( >=media-video/ffmpeg-3.2.2:0=[x264,x265] )
	jpeg? ( media-libs/libjpeg-turbo )
	pulseaudio? (
		media-sound/pulseaudio
		media-plugins/gst-plugins-pulse:1.0
	)
	sound? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	vpx? ( media-libs/libvpx media-video/ffmpeg )
	webp? ( media-libs/libwebp )
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/netifaces[${PYTHON_USEDEP}]
		dev-python/rencode[${PYTHON_USEDEP}]
		dev-python/pillow[jpeg?,${PYTHON_USEDEP}]
		cups? ( dev-python/pycups[${PYTHON_USEDEP}] )
		dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
		lz4? ( dev-python/lz4[${PYTHON_USEDEP}] )
		lzo? ( >=dev-python/python-lzo-0.7.0[${PYTHON_USEDEP}] )
		opengl? (
			client? ( dev-python/pyopengl_accelerate[${PYTHON_USEDEP}] )
		)
		webcam? (
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pyinotify[${PYTHON_USEDEP}]
			media-libs/opencv[${PYTHON_USEDEP},python]
		)
	')
	acct-group/xpra
	virtual/ssh
	x11-apps/xmodmap
	server? (
		x11-base/xorg-server[-minimal,xvfb]
		x11-drivers/xf86-input-void
	)
"
BDEPEND="
	virtual/pkgconfig
	$(python_gen_cond_dep '
		>=dev-python/cython-0.16[${PYTHON_USEDEP}]
	')
	doc? ( app-text/pandoc )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.2_ignore-gentoo-no-compile.patch
	"${FILESDIR}"/${PN}-3.0.2-ldconfig.patch
	"${FILESDIR}"/${PN}-4.0.3-suid-warning.patch
)

pkg_postinst() {
	tmpfiles_process /usr/lib/tmpfiles.d/xpra.conf

	xdg_pkg_postinst
}

python_prepare_all() {
	hprefixify -w '/os.path/' setup.py
	hprefixify tmpfiles.d/xpra.conf xpra/server/server_util.py \
		xpra/platform{/xposix,}/paths.py xpra/scripts/server.py

	sed -r -e "/\bdoc_dir =/s:/${PN}\":/${PF}/html\":" \
		-i setup.py || die

	if use minimal; then
		sed -r -e 's/^(pam|scripts|xdg_open)_ENABLED.*/\1_ENABLED=False/' \
			-i setup.py || die
	fi

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
		--without-cuda_rebuild
		--without-cuda_kernels
		$(use_with cups printing)
		--without-debug
		$(use_with dbus)
		$(use_with doc docs)
		$(use_with ffmpeg dec_avcodec2)
		$(use_with ffmpeg enc_ffmpeg)
		$(use_with ffmpeg enc_x264)
		$(use_with ffmpeg enc_x265)
		--with-gtk3
		$(use_with jpeg jpeg_encoder)
		$(use_with jpeg jpeg_decoder)
		--without-mdns
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

	export XPRA_SOCKET_DIRS="${EPREFIX}/run/xpra"
}
