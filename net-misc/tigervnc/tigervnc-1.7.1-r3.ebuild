# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CMAKE_IN_SOURCE_BUILD=1

inherit autotools cmake-utils eutils flag-o-matic java-pkg-opt-2 systemd

XSERVER_VERSION="1.19.1"

DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.tigervnc.org"
SRC_URI="https://github.com/TigerVNC/tigervnc/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~armin76/dist/tigervnc-1.4.2-patches-0.1.tar.bz2
	mirror://gentoo/${PN}.png
	server? ( ftp://ftp.freedesktop.org/pub/xorg/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.bz2	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="+drm gnutls nls java +opengl pam server +xorgmodule"

CDEPEND="virtual/jpeg:0
	sys-libs/zlib
	>=x11-libs/libXtst-1.0.99.2
	>=x11-libs/fltk-1.3.1
	gnutls? ( net-libs/gnutls:= )
	nls? ( virtual/libiconv )
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
		opengl? ( >=app-eselect/eselect-opengl-1.3.1-r1 )
		xorgmodule? ( =x11-base/xorg-server-${XSERVER_VERSION%.*}* )
		drm? ( x11-libs/libdrm )
	)"

RDEPEND="${CDEPEND}
	!net-misc/tightvnc
	!net-misc/vnc
	!net-misc/xf4vnc
	java? ( >=virtual/jre-1.5:* )"

DEPEND="${CDEPEND}
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	>=x11-proto/inputproto-2.2.99.1
	>=x11-proto/xextproto-7.2.99.901
	>=x11-proto/xproto-7.0.31
	x11-libs/libXfont2
	nls? ( sys-devel/gettext )
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
		opengl? ( >=media-libs/mesa-10.3.4-r1 )
	)"

PATCHES=(
	"${WORKDIR}"/patches/010_libvnc-os.patch
	"${WORKDIR}"/patches/030_manpages.patch
	"${WORKDIR}"/patches/055_xstartup.patch
)

src_prepare() {
	if use server ; then
		cp -r "${WORKDIR}"/xorg-server-${XSERVER_VERSION}/. unix/xserver || die
	fi

	default

	if use server; then
		eapply "${FILESDIR}/${PN}-1.7.1-xserver119-compat.patch"
		cd unix/xserver || die
		eapply "${FILESDIR}/xserver119.patch"
		eautoreconf
	fi
}

src_configure() {
	use arm || use hppa && append-flags "-fPIC"

	local mycmakeargs=(
		-DENABLE_GNUTLS=$(usex gnutls)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_PAM=$(usex pam)
		-DBUILD_JAVA=$(usex java)
	)

	cmake-utils_src_configure

	if use server; then
		cd unix/xserver || die
		econf \
			$(use_enable opengl glx) \
			$(use_enable drm libdrm) \
			--disable-config-hal \
			--disable-config-udev \
			--disable-devel-docs \
			--disable-dmx \
			--disable-dri \
			--disable-dri3 \
			--disable-glamor \
			--disable-kdrive \
			--disable-libunwind \
			--disable-linux-acpi \
			--disable-record \
			--disable-selective-werror \
			--disable-silent-rules \
			--disable-static \
			--disable-tslib \
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

	if use server; then
		# deps of the vnc module and the module itself
		local d subdirs=(
			fb xfixes Xext dbe $(usex opengl glx "") randr render damageext miext Xi xkb
			composite dix mi os hw/vnc
		)
		for d in "${subdirs[@]}"; do
			emake -C unix/xserver/"${d}"
		done
	fi
}

src_install() {
	cmake-utils_src_install

	newicon "${DISTDIR}"/tigervnc.png vncviewer.png
	make_desktop_entry vncviewer vncviewer vncviewer Network

	if use server ; then
		emake -C unix/xserver/hw/vnc DESTDIR="${D}" install
		if ! use xorgmodule; then
			rm -r "${ED%/}"/usr/$(get_libdir)/xorg || die
		else
			rm "${ED%/}"/usr/$(get_libdir)/xorg/modules/extensions/libvnc.la || die
		fi

		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_douserunit contrib/systemd/user/vncserver@.service
	else
		local f
		cd "${ED}" || die
		for f in vncserver vncpasswd x0vncserver vncconfig; do
			rm usr/bin/$f || die
			rm usr/share/man/man1/$f.1 || die
		done
	fi
}
