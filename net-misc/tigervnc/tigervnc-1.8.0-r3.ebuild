# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD=1

inherit autotools cmake-utils eutils flag-o-matic java-pkg-opt-2 systemd

XSERVER_VERSION="1.19.5"

DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.tigervnc.org"
SRC_URI="https://github.com/TigerVNC/tigervnc/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~armin76/dist/tigervnc-1.4.2-patches-0.1.tar.bz2
	server? ( ftp://ftp.freedesktop.org/pub/xorg/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.bz2	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ~ppc ~ppc64 ~sh sparc x86"
IUSE="+drm gnutls nls java +opengl pam server +xorgmodule xinerama dri3"

CDEPEND="virtual/jpeg:0
	sys-libs/zlib:=
	>=x11-libs/fltk-1.3.1
	gnutls? ( net-libs/gnutls:= )
	nls? ( virtual/libiconv )
	pam? ( virtual/pam )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	server? (
		x11-libs/libXau
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXfont2
		x11-libs/libXtst
		>=x11-libs/pixman-0.27.2
		>=x11-apps/xauth-1.0.3
		x11-apps/xsetroot
		>=x11-misc/xkeyboard-config-2.4.1-r3
		opengl? ( >=app-eselect/eselect-opengl-1.3.1-r1 )
		xorgmodule? ( =x11-base/xorg-server-${XSERVER_VERSION%.*}* )
		drm? ( x11-libs/libdrm )
	)
	xinerama? ( x11-libs/libXinerama )
	"

RDEPEND="${CDEPEND}
	!net-misc/tightvnc
	!net-misc/vnc
	!net-misc/xf4vnc
	java? ( >=virtual/jre-1.5:* )"

DEPEND="${CDEPEND}
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	nls? ( sys-devel/gettext )
	java? ( >=virtual/jdk-1.5 )
	x11-base/xorg-proto
	media-libs/fontconfig
	x11-base/xorg-proto
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXi
	server? (
		dev-libs/libbsd
		x11-libs/libxkbfile
		x11-libs/libxshmfence
		virtual/pkgconfig
		media-fonts/font-util
		x11-misc/util-macros
		>=x11-libs/xtrans-1.3.3
		opengl? ( >=media-libs/mesa-10.3.4-r1 )
	)"

PATCHES=(
	"${WORKDIR}"/patches/030_manpages.patch
	"${WORKDIR}"/patches/055_xstartup.patch
	"${FILESDIR}"/java-utf8.patch
)

src_prepare() {
	if use server ; then
		cp -r "${WORKDIR}"/xorg-server-${XSERVER_VERSION}/. unix/xserver || die
	fi

	cmake-utils_src_prepare

	if use server ; then
		cd unix/xserver || die
		eapply "${FILESDIR}"/xserver119.patch
		eautoreconf
	fi
}

src_configure() {
	if use arm || use hppa ; then
		append-flags "-fPIC"
	fi

	local mycmakeargs=(
		-DENABLE_GNUTLS=$(usex gnutls)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_PAM=$(usex pam)
		-DBUILD_JAVA=$(usex java)
	)

	cmake-utils_src_configure

	if use server ; then
		cd unix/xserver || die
		econf \
			$(use_enable opengl glx) \
			$(use_enable drm libdrm) \
			--disable-config-hal \
			--disable-config-udev \
			--disable-devel-docs \
			--disable-dmx \
			--disable-dri \
			$(use_enable dri3) \
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
			$(use_enable xinerama) \
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
		# deps of the vnc module and the module itself
		local d subdirs=(
			fb xfixes Xext dbe $(usex opengl glx "") $(usev dri3) randr render damageext miext Xi xkb
			composite dix mi os hw/vnc
		)
		for d in "${subdirs[@]}"; do
			emake -C unix/xserver/"${d}"
		done
	fi
}

src_install() {
	cmake-utils_src_install

	if use server ; then
		emake -C unix/xserver/hw/vnc DESTDIR="${D}" install
		if ! use xorgmodule; then
			rm -rv "${ED%/}"/usr/$(get_libdir)/xorg || die
		else
			rm -v "${ED%/}"/usr/$(get_libdir)/xorg/modules/extensions/libvnc.la || die
		fi

		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}

		systemd_douserunit contrib/systemd/user/vncserver@.service
	else
		local f
		cd "${ED}" || die
		for f in vncserver x0vncserver vncconfig; do
			rm usr/bin/$f || die
			rm usr/share/man/man1/$f.1 || die
		done
	fi
}
