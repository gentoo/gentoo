# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org driver for joystick input devices"

KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.10"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_install() {
	xorg-2_src_install
	insinto /usr/share/X11/xorg.conf.d
	doins config/50-joystick-all.conf
}
