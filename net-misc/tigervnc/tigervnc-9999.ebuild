# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=1
inherit autotools cmake flag-o-matic java-pkg-opt-2 optfeature systemd xdg

XSERVER_VERSION="21.1.13"
XSERVER_PATCH_VERSION="21"

DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="https://tigervnc.org"
SRC_URI="server? ( ftp://ftp.freedesktop.org/pub/xorg/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.xz )"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TigerVNC/tigervnc/"
else
	SRC_URI+=" https://github.com/TigerVNC/tigervnc/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="dri3 +drm gnutls java nls +opengl +server +viewer xinerama"
REQUIRED_USE="
	dri3? ( drm )
	java? ( viewer )
	opengl? ( server )
	|| ( server viewer )
"

# TODO: sys-libs/libselinux
COMMON_DEPEND="
	dev-libs/gmp:=
	dev-libs/nettle:=
	media-libs/libjpeg-turbo:=
	sys-libs/zlib:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
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
		x11-apps/xauth
		x11-apps/xinit
		x11-apps/xkbcomp
		x11-apps/xsetroot
		x11-misc/xkeyboard-config
		opengl? ( media-libs/libglvnd[X] )
		!net-misc/turbovnc[server]
	)
	viewer? (
		media-video/ffmpeg:=
		x11-libs/fltk:1
		x11-libs/libXi
		x11-libs/libXrender
		!net-misc/turbovnc[viewer]
	)
"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
	server? ( dev-lang/perl )
"
DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.8:* )
	drm? ( x11-libs/libdrm )
	server? (
		media-fonts/font-util
		x11-base/xorg-proto
		x11-libs/libxcvt
		x11-libs/libXi
		x11-libs/libxkbfile
		x11-libs/libXrender
		x11-libs/xtrans
		x11-misc/util-macros
		opengl? ( media-libs/mesa )
	)
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	# Restore Java viewer
	"${FILESDIR}"/${PN}-1.11.0-install-java-viewer.patch
	"${FILESDIR}"/${PN}-1.12.0-xsession-path.patch
	"${FILESDIR}"/${PN}-1.12.80-disable-server-and-pam.patch
)

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		use server && unpack xorg-server-${XSERVER_VERSION}.tar.xz
	else
		default
	fi
}

src_prepare() {
	if use server; then
		cp -r "${WORKDIR}"/xorg-server-${XSERVER_VERSION}/. unix/xserver || die
	fi

	cmake_src_prepare

	if use server; then
		cd unix/xserver || die
		eapply ../xserver${XSERVER_PATCH_VERSION}.patch
		eautoreconf
		sed -i '/strcmp.*-fakescreenfps/,/^        \}/d' os/utils.c || die

		if use drm; then
			cd "${WORKDIR}" && \
			sed -i 's:\(drm_fourcc.h\):libdrm/\1:' $(grep drm_fourcc.h -rl .) || die
		fi
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
		-DBUILD_VIEWER=$(usex viewer)
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
			--with-sha1=libcrypto
	fi
}

src_compile() {
	cmake_src_compile

	if use server; then
		# deps of the vnc module and the module itself
		local d subdirs=(
			fb xfixes Xext dbe $(usex opengl glx "") $(usev dri3) randr render
			damageext miext Xi xkb composite dix mi os present hw/vnc
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

		newconfd "${FILESDIR}"/${PN}-1.13.1.confd ${PN}
		newinitd "${FILESDIR}"/${PN}-1.13.90.initd ${PN}

		systemd_douserunit unix/vncserver/vncserver@.service

		# comment out pam_selinux.so, the server does not start if missing
		# part of bug #746227
		sed -i -e '/pam_selinux/s/^/#/' "${ED}"/etc/pam.d/tigervnc || die

		# install vncserver to /usr/bin too, see bug #836620
		dosym -r /usr/libexec/vncserver /usr/bin/vncserver
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	use server && [[ -n ${REPLACING_VERSIONS} ]] && ver_test "${REPLACING_VERSIONS}" -lt 1.13.1-r3 && {
		elog 'OpenRC users: please migrate to one service per display as documented here:'
		elog 'https://wiki.gentoo.org/wiki/TigerVNC#Migrating_from_1.13.1-r2_or_lower:'
		elog
	}

	local OPTIONAL_DM="gnome-base/gdm x11-misc/lightdm x11-misc/sddm x11-misc/slim"
	use server && \
		optfeature "keeping track of the xorg-server module" net-misc/tigervnc-xorg-module && \
		optfeature_header "Install any additional display manager package:" && \
		optfeature "proper session support" ${OPTIONAL_DM}
}
