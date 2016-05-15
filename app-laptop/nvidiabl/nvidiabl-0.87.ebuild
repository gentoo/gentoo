# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit linux-mod eutils

DESCRIPTION="Linux driver for setting the backlight brightness on laptops using NVIDIA GPU"
HOMEPAGE="https://github.com/guillaumezin/nvidiabl"
SRC_URI="https://github.com/guillaumezin/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_setup() {
	CONFIG_CHECK="FB_BACKLIGHT"
	ERROR_FB_BACKLIGHT="Your kernel does not support FB_BACKLIGHT. To enable you
it you can enable any frame buffer with backlight control or nouveau.
Note that you cannot use FB_NVIDIA with nvidia's proprietary driver"
	linux-mod_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-linux-4.0.patch
}

src_compile() {
	BUILD_PARAMS="KVER=${KV_FULL}"
	BUILD_TARGETS="modules"
	MODULE_NAMES="nvidiabl()"

	MAKEOPTS+=" V=1"
	linux-mod_src_compile
}
