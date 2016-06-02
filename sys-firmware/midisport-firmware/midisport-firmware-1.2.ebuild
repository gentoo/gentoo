# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools linux-info udev

DESCRIPTION="Firmware for M-Audio/Midiman USB MIDI devices"
HOMEPAGE="http://usb-midi-fw.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/usb-midi-fw/${P}.tar.gz"

LICENSE="Midisport"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/fxload
	virtual/udev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~SND_USB_AUDIO"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-rules.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-udev="$(get_udevdir)"
}
