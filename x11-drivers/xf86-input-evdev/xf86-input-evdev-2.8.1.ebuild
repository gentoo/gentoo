# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-evdev/xf86-input-evdev-2.8.1.ebuild,v 1.10 2013/10/08 05:05:15 ago Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="Generic Linux input driver"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.12[udev]
	sys-libs/mtdev"
DEPEND="${RDEPEND}
	>=x11-proto/inputproto-2.1.99.3
	>=sys-kernel/linux-headers-2.6"
