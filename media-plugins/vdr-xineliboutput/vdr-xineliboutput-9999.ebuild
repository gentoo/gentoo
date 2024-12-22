# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_VDR_CONDITIONAL=yes

inherit flag-o-matic git-r3 toolchain-funcs vdr-plugin-2

DESCRIPTION="VDR Plugin: Xinelib PlugIn"
HOMEPAGE="https://sourceforge.net/projects/xineliboutput/"
EGIT_REPO_URI="https://git.code.sf.net/p/xineliboutput/git"
S="${WORKDIR}/${P}"

LICENSE="GPL-2+"
SLOT="0"
IUSE="bluray caps cec dbus fbcon jpeg nls opengl +vdr vdpau wayland +X +xine xinerama"

COMMON_DEPEND="
	vdr? (
		media-video/vdr
		caps? ( sys-libs/libcap )
	)

	xine? (
		( >=media-libs/xine-lib-1.2
			media-video/ffmpeg )
		fbcon? ( jpeg? ( media-libs/libjpeg-turbo:= ) )
		X? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXrender
			xinerama? ( x11-libs/libXinerama )
			dbus? ( dev-libs/dbus-glib dev-libs/glib:2 )
			vdpau? ( x11-libs/libvdpau >=media-libs/xine-lib-1.2 )
			jpeg? ( media-libs/libjpeg-turbo:= )
			bluray? ( media-libs/libbluray )
			opengl? ( virtual/opengl )
		)
		wayland? (
			>=media-libs/xine-lib-1.2.10[wayland]
			bluray? ( media-libs/libbluray )
			dbus? ( dev-libs/dbus-glib dev-libs/glib:2 )
			jpeg? ( media-libs/libjpeg-turbo:= )
			opengl? ( virtual/opengl )
			vdpau? ( x11-libs/libvdpau >=media-libs/xine-lib-1.2.10[vdpau] )
		)
	)

	cec? ( dev-libs/libcec )"

DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers
	nls? ( sys-devel/gettext )
	xine? (
		X? (
			x11-base/xorg-proto
			x11-libs/libXxf86vm
		)
	)"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="acct-user/vdr
	virtual/pkgconfig"

VDR_CONFD_FILE="${FILESDIR}/confd-2.3.0"

pkg_setup() {
	if ! use vdr && ! use xine; then
		die "You either need at least one of these flags: vdr xine"
	fi

	vdr-plugin-2_pkg_setup

	if use xine; then
		XINE_PLUGIN_DIR=$($(tc-getPKG_CONFIG) --variable=plugindir libxine)
		[ -z "${XINE_PLUGIN_DIR}" ] && die "Could not find xine plugin dir"
	fi
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	# Allow user patches to be applied without modifyfing the ebuild
	eapply_user

	vdr-plugin-2_src_prepare

	# UINT64_C is needed by ffmpeg headers
	append-cxxflags -D__STDC_CONSTANT_MACROS
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
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		$(use_enable X x11) \
		$(use_enable X xshm) \
		$(use_enable X xdpms) \
		$(use_enable X xshape) \
		$(use_enable X xrender) \
		$(use_enable fbcon fb) \
		$(use_enable vdr) \
		$(use_enable xine libxine) \
		--disable-libextractor \
		$(use_enable caps libcap) \
		$(use_enable jpeg libjpeg) \
		$(use_enable xinerama) \
		$(use_enable dbus dbus-glib-1) \
		$(use_enable nls i18n) \
		$(use_enable bluray libbluray) \
		$(use_enable opengl) \
		$(use_enable wayland) \
		$(use_enable cec libcec) \
		${myconf} \
		|| die
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
			newinitd "${FILESDIR}"/vdr-frontend-r1 vdr-frontend

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
			if use wayland; then
				dobin vdr-wlfe

				insinto $VDR_PLUGIN_DIR
				doins libxineliboutput-wlfe.so.*
			fi
		fi
	else
		emake DESTDIR="${D}" install
	fi
	dodoc HISTORY README
}
