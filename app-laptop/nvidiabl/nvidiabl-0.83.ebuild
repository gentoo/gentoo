# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/nvidiabl/nvidiabl-0.83.ebuild,v 1.5 2014/12/27 19:29:18 ago Exp $

EAPI=5
inherit linux-mod

DESCRIPTION="Linux driver for setting the backlight brightness on laptops using
NVIDIA GPU"
HOMEPAGE="https://github.com/guillaumezin/nvidiabl"
SRC_URI="https://github.com/guillaumezin/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

RESTRICT="test"

BUILD_TARGETS="modules"
MODULE_NAMES="nvidiabl()"

pkg_pretend() {
	CONFIG_CHECK="FB_BACKLIGHT"
	ERROR_FB_BACKLIGHT="Your kernel does not support FB_BACKLIGHT. To enable you
it you can enable any frame buffer with backlight control or nouveau.
Note that you cannot use FB_NVIDIA with nvidia's proprietary driver"
	linux-mod_pkg_setup
}

src_compile() {
	BUILD_PARAMS="KVER=${KV_FULL}"
	MAKEOPTS+=" V=1"
	linux-mod_src_compile
}
