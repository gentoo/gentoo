# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/Xpra-org/xpra.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
		https://dev.gentoo.org/~chewi/distfiles/${PN}-4.3.1-tests.patch"
	KEYWORDS="~amd64 ~x86"
fi

PYTHON_COMPAT=( python3_{7,8,9,10} )
DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_SETUPTOOLS=no

inherit xdg xdg-utils distutils-r1 tmpfiles udev

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy"
HOMEPAGE="https://xpra.org/"
LICENSE="GPL-2 BSD"
SLOT="0"
IUSE="brotli +client +clipboard csc cups dbus doc ffmpeg jpeg html ibus +lz4 lzo minimal opengl pillow pinentry pulseaudio +server sound systemd test udev vpx webcam webp xdg xinerama"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( client server )
	cups? ( dbus )
	opengl? ( client )
	test? ( client clipboard dbus html server sound xdg xinerama )
"

TDEPEND="
	$(python_gen_cond_dep '
		dev-python/netifaces[${PYTHON_USEDEP}]
		dev-python/pillow[jpeg?,${PYTHON_USEDEP}]
		dev-python/rencode[${PYTHON_USEDEP}]
		dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
		xdg? ( dev-python/pyxdg[${PYTHON_USEDEP}] )
	')
	html? ( www-apps/xpra-html5 )
	server? (
		x11-base/xorg-server[-minimal,xvfb]
		x11-drivers/xf86-input-void
	)
	xinerama? ( x11-libs/libfakeXinerama )
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
	x11-libs/libXres
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
	${TDEPEND}
	$(python_gen_cond_dep '
		cups? ( dev-python/pycups[${PYTHON_USEDEP}] )
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
	x11-apps/xauth
	x11-apps/xmodmap
	ibus? ( app-i18n/ibus )
	pinentry? ( app-crypt/pinentry )
	udev? ( virtual/udev )
"
DEPEND+="
	test? ( ${TDEPEND} )
"
BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cython-0.16[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig
	doc? ( app-text/pandoc )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.2_ignore-gentoo-no-compile.patch
	"${FILESDIR}"/${PN}-4.3-no-service.patch
	"${DISTDIR}"/${PN}-4.3.1-tests.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	# FIXME: There are hardcoded paths all over the place but the following
	# double-prefixes some files under /etc. Looks tricky to fix. :(
	#hprefixify $(find -type f \( -name "*.py" -o -name "*.conf" \))

	sed -r -e "/\bdoc_dir =/s:/${PN}\":/${PF}/html\":" \
		-i setup.py || die

	if use minimal; then
		sed -r -e 's/^(pam|scripts|xdg_open)_ENABLED.*/\1_ENABLED=False/' \
			-i setup.py || die
	fi
}

python_configure_all() {
	sed -e "/'pulseaudio'/s:DEFAULT_PULSEAUDIO:$(usex pulseaudio True False):" \
		-i setup.py || die

	DISTUTILS_ARGS=(
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

python_test() {
	export XAUTHORITY=${HOME}/.Xauthority
	touch "${XAUTHORITY}" || die

	distutils_install_for_testing
	xdg_environment_reset

	env -u WAYLAND_DISPLAY -u XDG_SESSION_TYPE \
	PYTHONPATH="${S}/tests/unittests:${BUILD_DIR}/test/lib" \
	XPRA_SYSTEMD_RUN=$(usex systemd) XPRA_TEST_COVERAGE=0 \
		"${PYTHON}" "${S}"/tests/unittests/unit/run.py || die
}

python_install_all() {
	distutils-r1_python_prepare_all

	# Move udev dir to the right place.
	if use udev; then
		local dir=$(get_udevdir)
		dodir "${dir%/*}"
		mv -vnT "${ED}"/usr/lib/udev "${ED}${dir}" || die
	else
		rm -vr "${ED}"/usr/lib/udev || die
	fi
}

pkg_postinst() {
	tmpfiles_process xpra.conf
	xdg_pkg_postinst
	use udev && udev_reload
}

pkg_postrm() {
	xdg_pkg_postinst
	use udev && udev_reload
}
