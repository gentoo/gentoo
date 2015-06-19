# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tigervnc/tigervnc-1.3.1-r4.ebuild,v 1.13 2015/04/26 16:03:39 zlogene Exp $

EAPI="4"

inherit eutils cmake-utils autotools java-pkg-opt-2 flag-o-matic

PATCHVER="0.1"
XSERVER_VERSION="1.16.0"
OPENGL_DIR="xorg-x11"
#MY_P="${PN}-1.2.80-20130314svn5065"
#S="${WORKDIR}/${MY_P}"

DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.tigervnc.org"
SRC_URI="mirror://sourceforge/tigervnc/${P}.tar.gz
	mirror://gentoo/${PN}.png
	mirror://gentoo/${PN}-1.3.1-patches-${PATCHVER}.tar.bz2
	http://dev.gentoo.org/~armin76/dist/${PN}-1.3.1-patches-${PATCHVER}.tar.bz2
	server? ( ftp://ftp.freedesktop.org/pub/xorg/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.bz2	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE="gnutls java nptl +opengl pam server +xorgmodule"

RDEPEND="virtual/jpeg:0
	sys-libs/zlib
	>=x11-libs/libXtst-1.0.99.2
	>=x11-libs/fltk-1.3.1
	gnutls? ( net-libs/gnutls )
	java? ( >=virtual/jre-1.5 )
	pam? ( virtual/pam )
	server? (
		dev-lang/perl
		>=x11-libs/libXi-1.2.99.1
		>=x11-libs/libXfont-1.4.2
		>=x11-libs/libxkbfile-1.0.4
		x11-libs/libXrender
		>=x11-libs/pixman-0.27.2
		>=x11-apps/xauth-1.0.3
		x11-apps/xsetroot
		>=x11-misc/xkeyboard-config-2.4.1-r3
		opengl? ( >=app-eselect/eselect-opengl-1.0.8 )
		xorgmodule? ( =x11-base/xorg-server-${XSERVER_VERSION%.*}* )
	)
	!net-misc/vnc
	!net-misc/tightvnc
	!net-misc/xf4vnc"
DEPEND="${RDEPEND}
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	>=x11-proto/inputproto-2.2.99.1
	>=x11-proto/xextproto-7.2.99.901
	>=x11-proto/xproto-7.0.26
	java? ( >=virtual/jdk-1.5 )
	server?	(
		virtual/pkgconfig
		media-fonts/font-util
		x11-misc/util-macros
		>=x11-proto/bigreqsproto-1.1.0
		>=x11-proto/compositeproto-0.4
		>=x11-proto/damageproto-1.1
		>=x11-proto/fixesproto-5.0
		>=x11-proto/fontsproto-2.1.3
		>=x11-proto/glproto-1.4.17
		>=x11-proto/randrproto-1.4.0
		>=x11-proto/renderproto-0.11
		>=x11-proto/resourceproto-1.2.0
		>=x11-proto/scrnsaverproto-1.1
		>=x11-proto/videoproto-2.2.2
		>=x11-proto/xcmiscproto-1.2.0
		>=x11-proto/xineramaproto-1.1.3
		>=x11-libs/xtrans-1.3.3
		>=x11-proto/dri2proto-2.8
		opengl? ( >=media-libs/mesa-7.8_rc[nptl=] )
	)"

CMAKE_IN_SOURCE_BUILD=1

pkg_setup() {
	if ! use server ; then
		echo
		einfo "The 'server' USE flag will build tigervnc's server."
		einfo "If '-server' is chosen only the client is built to save space."
		einfo "Stop the build now if you need to add 'server' to USE flags.\n"
	else
		ewarn "Forcing on xorg-x11 for new enough glxtokens.h..."
		OLD_IMPLEM="$(eselect opengl show)"
		eselect opengl set ${OPENGL_DIR}
	fi
}

switch_opengl_implem() {
	# Switch to the xorg implementation.
	# Use new opengl-update that will not reset user selected
	# OpenGL interface ...
	echo
	eselect opengl set ${OLD_IMPLEM}
}

src_prepare() {
	if use server ; then
		cp -r "${WORKDIR}"/xorg-server-${XSERVER_VERSION}/* unix/xserver
	else
		rm "${WORKDIR}"/patches/*_server_*
	fi

	EPATCH_SOURCE="${WORKDIR}/patches" EPATCH_SUFFIX="patch" EPATCH_EXCLUDE="*999*" \
		EPATCH_FORCE="yes" epatch

	epatch "${FILESDIR}"/1.3.1-CVE-2014-8240.patch

	if use server ; then
		cd unix/xserver
		epatch "${WORKDIR}"/patches/0999_server_xserver-1.14-rebased.patch
		eautoreconf
	fi
}

src_configure() {

	use arm || use hppa && append-flags "-fPIC"

	mycmakeargs=(
		-G "Unix Makefiles"
		$(cmake-utils_use_enable gnutls GNUTLS)
		$(cmake-utils_use_enable pam PAM)
		$(cmake-utils_use_build java JAVA)
	)

	cmake-utils_src_configure

	if use server; then
		cd unix/xserver
		econf \
			$(use_enable nptl glx-tls) \
			$(use_enable opengl glx) \
			--disable-config-hal \
			--disable-config-udev \
			--disable-devel-docs \
			--disable-dmx \
			--disable-dri \
			--disable-dri3 \
			--disable-kdrive \
			--disable-selective-werror \
			--disable-silent-rules \
			--disable-static \
			--disable-unit-tests \
			--disable-xephyr \
			--disable-xinerama \
			--disable-xnest \
			--disable-xorg \
			--disable-xvfb \
			--disable-xwin \
			--disable-xwayland \
			--enable-dri2 \
			--with-pic \
			--without-dtrace \
			--disable-present \
			--disable-unit-tests
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use server ; then
		cd unix/xserver
		emake
	fi
}

src_install() {
	cmake-utils_src_install

	newicon "${DISTDIR}"/tigervnc.png vncviewer.png
	make_desktop_entry vncviewer vncviewer vncviewer Network

	if use server ; then
		cd unix/xserver/hw/vnc
		emake DESTDIR="${D}" install
		! use xorgmodule && rm -rf "${D}"/usr/$(get_libdir)/xorg

		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}

		rm "${D}"/usr/$(get_libdir)/xorg/modules/extensions/libvnc.la
	else
		cd "${D}"
		for f in vncserver vncpasswd x0vncserver vncconfig; do
			rm usr/bin/$f
			rm usr/share/man/man1/$f.1
		done
	fi
}

pkg_postinst() {
	use server && switch_opengl_implem
}
