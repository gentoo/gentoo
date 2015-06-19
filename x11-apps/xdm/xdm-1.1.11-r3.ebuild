# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xdm/xdm-1.1.11-r3.ebuild,v 1.12 2015/03/03 10:41:19 dlan Exp $

EAPI=5

XORG_EAUTORECONF=yes

inherit multilib xorg-2 pam systemd

DEFAULTVT=vt7

DESCRIPTION="X.Org xdm application"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="consolekit ipv6 pam xdm-auth"

RDEPEND="x11-apps/xrdb
	x11-libs/libXdmcp
	x11-libs/libXaw
	>=x11-apps/xinit-1.0.2-r3
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXt
	x11-apps/sessreg
	x11-apps/xconsole
	consolekit? ( sys-auth/consolekit )
	pam? ( virtual/pam )
	!<sys-apps/systemd-187"
DEPEND="${RDEPEND}
	consolekit? ( !=sys-auth/pambase-20101024-r1 )
	x11-proto/xineramaproto
	x11-proto/xproto"

pkg_setup() {
	PATCHES=(
		"${FILESDIR}"/${PN}-consolekit.patch
		"${FILESDIR}"/${P}-cve-2013-2179.patch
		"${FILESDIR}"/${PN}-1.1.11-arc4random-include.patch
		"${FILESDIR}"/${PN}-1.1.11-setproctitle-include.patch
	)

	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_with pam)
		"$(systemd_with_unitdir)"
		--with-default-vt=${DEFAULTVT}
		--with-xdmconfigdir=/etc/X11/xdm
		$(use_with consolekit)
	)
}

src_prepare() {
	# fedora invented that in -187...
	sed -i -e 's:^Alias=.*$:Alias=display-manager.service:' \
		xdm.service.in || die

	# disable XDM-AUTHENTICATION-1 wrt bug #445662.
	# it causes issue with libreoffice and SDL games (bug #306223).
	if use !xdm-auth; then
		sed -i -e '/authorize/a\
DisplayManager*authName:	MIT-MAGIC-COOKIE-1' \
			config/xdm-config.cpp || die
	fi
	xorg-2_src_prepare
}

src_install() {
	xorg-2_src_install

	exeinto /usr/$(get_libdir)/X11/xdm
	doexe "${FILESDIR}"/Xsession

	use pam && pamd_mimic system-local-login xdm auth account session

	# Keep /var/lib/xdm. This is where authfiles are stored. See #286350.
	keepdir /var/lib/xdm
}
