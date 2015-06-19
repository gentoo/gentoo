# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-joystick/xf86-input-joystick-1.6.2.ebuild,v 1.10 2013/10/08 05:05:18 ago Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org driver for joystick input devices"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.10"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/kbproto"

src_install() {
	xorg-2_src_install
	insinto /usr/share/X11/xorg.conf.d
	doins config/50-joystick-all.conf
}
