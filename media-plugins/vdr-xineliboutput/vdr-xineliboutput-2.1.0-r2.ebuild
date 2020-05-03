# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs vdr-plugin-2

GENTOO_VDR_CONDITIONAL=yes

DESCRIPTION="VDR Plugin: Xinelib PlugIn"
HOMEPAGE="https://sourceforge.net/projects/xineliboutput/"
SRC_URI="mirror://sourceforge/${PN#vdr-}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="bluray caps cec dbus fbcon jpeg libextractor nls opengl +vdr vaapi vdpau +X +xine xinerama"

COMMON_DEPEND="
	vdr? (
		media-video/vdr
		libextractor? ( >=media-libs/libextractor-0.5.20 )
		caps? ( sys-libs/libcap )
	)

	xine? (
		( >=media-libs/xine-lib-1.2
			media-video/ffmpeg )
		fbcon? ( jpeg? ( virtual/jpeg:* ) )
		X? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXrender
			bluray? ( media-libs/libbluray )
			dbus? ( dev-libs/dbus-glib dev-libs/glib:2 )
			jpeg? ( virtual/jpeg:* )
			opengl? ( virtual/opengl )
			vaapi? ( x11-libs/libva >=media-libs/xine-lib-1.2[vaapi] )
			vdpau? ( x11-libs/libvdpau >=media-libs/xine-lib-1.2[vdpau] )
			xinerama? ( x11-libs/libXinerama )
		)
	)"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	sys-kernel/linux-headers
	nls? ( sys-devel/gettext )
	xine? (
		X? (
			x11-base/xorg-proto
			x11-libs/libXxf86vm
		)
	)"
RDEPEND="${COMMON_DEPEND}"

REQUIRED_USE=" || ( vdr xine )"

VDR_CONFD_FILE="${FILESDIR}/confd-2.0.0"

pkg_setup() {
	vdr-plugin-2_pkg_setup

	if use xine; then
		XINE_PLUGIN_DIR=$(pkg-config --variable=plugindir libxine)
		[ -z "${XINE_PLUGIN_DIR}" ] && die "Could not find xine plugin dir"
	fi
}

src_prepare() {
	vdr-plugin-2_src_prepare

	# bug 711978
	sed -e "s:X11  opengl:X11  OpenGl:" -i configure || die
}

src_configure() {
	local myconf

	if has_version ">=media-libs/xine-lib-1.2"; then
		myconf="${myconf} --enable-libavutil"
	else
		myconf="${myconf} --disable-libavutil"
	fi

	# No autotools based configure script
	./configure \
		--cc=$(tc-getCC) \
		--cxx=$(tc-getCXX) \
		$(use_enable X x11) \
		$(use_enable X xshm) \
		$(use_enable X xdpms) \
		$(use_enable X xshape) \
		$(use_enable X xrandr) \
		$(use_enable X xrender) \
		$(use_enable fbcon fb) \
		$(use_enable vdr) \
		$(use_enable xine libxine) \
		$(use_enable libextractor) \
		$(use_enable caps libcap) \
		$(use_enable cec libcec) \
		$(use_enable jpeg libjpeg) \
		$(use_enable xinerama) \
		$(use_enable vdpau) \
		$(use_enable dbus dbus-glib-1) \
		$(use_enable nls i18n) \
		$(use_enable bluray libbluray) \
		$(use_enable opengl) \
		${myconf} \
		|| die

	# UINT64_C is needed by ffmpeg headers
	append-cxxflags -D__STDC_CONSTANT_MACROS
}

src_install() {
	if use vdr; then
		vdr-plugin-2_src_install

		# bug 346989
		insinto /etc/vdr/plugins/xineliboutput/
		doins examples/allowed_hosts.conf
		fowners -R vdr:vdr /etc/vdr/

		if use nls; then
			emake DESTDIR="${D}" i18n
		fi

		if use xine; then
			doinitd "${FILESDIR}"/vdr-frontend

			insinto $XINE_PLUGIN_DIR
			doins xineplug_inp_xvdr.so

			insinto $XINE_PLUGIN_DIR/post
			doins xineplug_post_*.so

			if use fbcon; then
				dobin vdr-fbfe

				insinto $VDR_PLUGIN_DIR
				doins libxineliboutput-fbfe.so.*
			fi

			if use X; then
				dobin vdr-sxfe

				insinto $VDR_PLUGIN_DIR
				doins libxineliboutput-sxfe.so.*
			fi
		fi
	else
		emake DESTDIR="${D}" install

		dodoc HISTORY README
	fi
}
