# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3 pam systemd

DEFAULTVT=vt7

DESCRIPTION="X.Org xdm application"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="pam systemd truetype xinerama xpm"

RDEPEND="
	x11-apps/sessreg
	x11-apps/xconsole
	x11-apps/xinit
	x11-apps/xrdb
	x11-apps/xsm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXaw
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	virtual/libcrypt:=
	pam? ( sys-libs/pam )
	systemd? ( >=sys-apps/systemd-209:= )
	truetype? (
		x11-libs/libXrender
		x11-libs/libXft
	)
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )
	elibc_glibc? ( dev-libs/libbsd )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	sed -i -e 's:^Alias=.*$:Alias=display-manager.service:' \
		xdm.service.in || die

	# Disable XDM-AUTHORIZATION-1 (bug #445662).
	# it causes issue with libreoffice and SDL games (bug #306223).
	sed -i -e '/authorize/a DisplayManager*authName:	MIT-MAGIC-COOKIE-1' \
			config/xdm-config.in || die

	xorg-3_src_prepare
}

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--enable-ipv6
		$(use_with pam)
		$(use_with systemd systemd-daemon)
		$(use_with truetype xft)
		$(use_with xinerama)
		$(use_enable xpm xpm-logos)
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-default-vt=${DEFAULTVT}
		--with-xdmconfigdir=/etc/X11/xdm
	)
	xorg-3_src_configure
}

src_install() {
	xorg-3_src_install

	exeinto /usr/$(get_libdir)/X11/xdm
	doexe "${FILESDIR}"/Xsession

	use pam && pamd_mimic system-local-login xdm auth account session

	# Keep /var/lib/xdm. This is where authfiles are stored. See #286350.
	keepdir /var/lib/xdm
}
