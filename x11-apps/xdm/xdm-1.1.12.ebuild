# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_EAUTORECONF=yes

inherit xorg-3 pam systemd

DEFAULTVT=vt7

DESCRIPTION="X.Org xdm application"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="consolekit ipv6 pam systemd truetype xinerama xpm"

RDEPEND="
	x11-apps/sessreg
	x11-apps/xconsole
	x11-apps/xinit
	x11-apps/xrdb
	x11-apps/xsm
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXdmcp
	x11-libs/libXmu
	x11-libs/libXt
	consolekit? ( sys-auth/consolekit )
	pam? ( sys-libs/pam )
	systemd? ( >=sys-apps/systemd-209 )
	truetype? (
		x11-libs/libXrender
		x11-libs/libXft
	)
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )
	elibc_glibc? ( dev-libs/libbsd )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	consolekit? ( !=sys-auth/pambase-20101024-r1 )"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${P}-consolekit.patch
		"${FILESDIR}"/${P}-make-xinerama-optional.patch
	)

	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_with consolekit)
		$(use_with pam)
		$(use_with systemd systemd-daemon)
		$(use_with truetype xft)
		$(use_with xinerama)
		$(use_enable xpm xpm-logos)
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-default-vt=${DEFAULTVT}
		--with-xdmconfigdir=/etc/X11/xdm
	)
}

src_prepare() {
	sed -i -e 's:^Alias=.*$:Alias=display-manager.service:' \
		xdm.service.in || die

	# Disable XDM-AUTHORIZATION-1 (bug #445662).
	# it causes issue with libreoffice and SDL games (bug #306223).
	sed -i -e '/authorize/a DisplayManager*authName:	MIT-MAGIC-COOKIE-1' \
			config/xdm-config.in || die

	xorg-3_src_prepare
}

src_install() {
	xorg-3_src_install

	exeinto /usr/$(get_libdir)/X11/xdm
	doexe "${FILESDIR}"/Xsession

	use pam && pamd_mimic system-local-login xdm auth account session

	# Keep /var/lib/xdm. This is where authfiles are stored. See #286350.
	keepdir /var/lib/xdm
}
