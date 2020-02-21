# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit udev xorg-2

DESCRIPTION="VMWare mouse input driver"
IUSE=""
KEYWORDS="amd64 x86"

RDEPEND=""
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		--with-hal-bin-dir=/punt
		--with-hal-callouts-dir=/punt
		--with-hal-fdi-dir=/punt
		--with-udev-rules-dir=$(get_udevdir)/rules.d
	)

	xorg-2_pkg_setup
}

src_install() {
	xorg-2_src_install
	rm -rf "${ED}"/punt
}
