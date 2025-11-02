# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X.Org driver for joystick input devices"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~m68k ppc ppc64 ~sparc x86"

src_install() {
	xorg-3_src_install

	insinto /usr/share/X11/xorg.conf.d
	doins config/50-joystick-all.conf
}
