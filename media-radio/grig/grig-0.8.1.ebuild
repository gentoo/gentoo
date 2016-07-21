# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A tool for controlling amateur radios"
HOMEPAGE="http://groundstation.sourceforge.net/grig/"
SRC_URI="mirror://sourceforge/groundstation/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	media-libs/hamlib"
RDEPEND="${DEPEND}"

src_configure() {
	econf --enable-hardware
}

src_install() {
	default
	make_desktop_entry ${PN} "GRig" "/usr/share/pixmaps/grig/grig-logo.png" "HamRadio"
	rm -rf "${D}/usr/share/grig" || die "cleanup docs failed"
}
