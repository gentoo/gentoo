# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD=1
inherit autotools cmake eapi8-dosym flag-o-matic java-pkg-opt-2 optfeature systemd xdg

XSERVER_VERSION="21.1.1"

DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="https://tigervnc.org"
SRC_URI="https://github.com/TigerVNC/tigervnc/archive/v${PV}.tar.gz -> ${P}.tar.gz
	server? (
		ftp://ftp.freedesktop.org/pub/xorg/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.xz
		https://github.com/TigerVNC/tigervnc/commit/0c5a2b2e7759c2829c07186cfce4d24aa9b5274e.patch -> ${P}-xserver-21.patch
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="dri3 +drm gnutls java nls +opengl +server xinerama"
REQUIRED_USE="
	dri3? ( drm )
	opengl? ( server )
"

CDEPEND="
	media-libs/libjpeg-turbo:=
	sys-libs/zlib:=
	x11-libs/fltk:1
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pixman
	gnutls? ( net-libs/gnutls:= )
	nls? ( virtual/libiconv )
	server? (
		dev-libs/libbsd
		dev-libs/openssl:0=
		sys-libs/pam
		x11-libs/libXau
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXfixes
		x11-libs/libXfont2
		x11-libs/libXtst
		x11-libs/pixman
		x11-libs/xtrans
		x11-apps/xauth
		x11-apps/xinit
		x11-apps/xkbcomp
		x11-apps/xsetroot
		x11-misc/xkeyboard-config
		opengl? ( media-libs/libglvnd[X] )
	)
	"

RDEPEND="${CDEPEND}
	java? ( virtual/jre:1.8 )
	server? (
		dev-lang/perl
		sys-process/psmisc
	)"

DEPEND="${CDEPEND}
	drm? ( x11-libs/libdrm )
	server? (
		media-fonts/font-util
		x11-base/xorg-proto
		x11-libs/libxcvt
		x11-libs/libxkbfile
		x11-misc/util-macros
		opengl? ( media-libs/mesa )
	)"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	"

PATCHES=(
	# Restore Java viewer
	"${FILESDIR}"/${PN}-1.11.0-install-java-viewer.patch
	"${FILESDIR}"/${PN}-1.12.0-xsession-path.patch
	"${FILESDIR}"/${PN}-1.12.0-disable-server-and-pam.patch
)

src_prepare() {
	if use server; then
		cp -r "${WORKDIR}"/xorg-server-${XSERVER_VERSION}/. unix/xserver || die
		eapply "${FILESDIR}"/${P}-xorg-1.21.patch
		eapply "${DISTDIR}"/${P}-xserver-21.patch
	fi

	cmake_src_prepare

	if use server; then
		cd unix/xserver || die
		eapply ../xserver${XSERVER_VERSION}.patch
		eautoreconf
		sed -i 's:\(present.h\):../present/\1:' os/utils.c || die
		sed -i '/strcmp.*-fakescreenfps/,/^        \}/d' os/utils.c || die
	fi
}

src_configure() {
	if use arm || use hppa; then
		append-flags "-fPIC"
	fi

	local mycmakeargs=(
		-DENABLE_GNUTLS=$(usex gnutls)
		-DENABLE_NLS=$(usex nls)
		-DBUILD_JAVA=$(usex java)
		-DBUILD_SERVER=$(usex server)
	)

	cmake_src_configure

	if use server; then
		cd unix/xserver || die
		econf \
			$(use_enable opengl glx) \
			$(use_enable drm libdrm) \
			--disable-config-hal \
			--disable-config-udev \
			--disable-devel-docs \
			--disable-dri \
			$(use_enable dri3) \
			--disable-glamor \
			--disable-kdrive \
			--disable-libunwind \
			--disable-linux-acpi \
			--disable-record \
			--disable-selective-werror \
			--disable-static \
			--disable-unit-tests \
			--disable-xephyr \
			$(use_enable xinerama) \
			--disable-xnest \
			--disable-xorg \
			--disable-xvfb \
			--disable-xwin \
			--enable-dri2 \
			--with-pic \
			--without-dtrace \
			--disable-present \
			--with-sha1=libcrypto
	fi
}

src_compile() {
	cmake_src_compile

	if use server; then
		# deps of the vnc module and the module itself
		local d subdirs=(
			fb xfixes Xext dbe $(usex opengl glx "") $(usev dri3) randr render
			damageext miext Xi xkb composite dix mi os hw/vnc
		)
		for d in "${subdirs[@]}"; do
			emake -C unix/xserver/"${d}"
		done
	fi
}

src_install() {
	cmake_src_install

	if use server; then
		emake -C unix/xserver/hw/vnc DESTDIR="${D}" install
		rm -v "${ED}"/usr/$(get_libdir)/xorg/modules/extensions/libvnc.la || die

		newconfd "${FILESDIR}"/${PN}-${PV}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}-${PV}.initd ${PN}

		systemd_douserunit unix/vncserver/vncserver@.service

		# comment out pam_selinux.so, the server does not start if missing
		# part of bug #746227
		sed -i -e '/pam_selinux/s/^/#/' "${ED}"/etc/pam.d/tigervnc || die

		# install vncserver to /usr/bin too, see bug #836620
		dosym8 -r /usr/libexec/vncserver /usr/bin/vncserver
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	local OPTIONAL_DM="gnome-base/gdm x11-misc/lightdm x11-misc/sddm x11-misc/slim"
	use server && \
		optfeature "keeping track of the xorg-server module" net-misc/tigervnc-xorg-module && \
		optfeature_header "Install any additional display manager package:" && \
		optfeature "proper session support" ${OPTIONAL_DM}
}
