# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit unpacker

DESCRIPTION="A sophisticated software modeler"
HOMEPAGE="http://staruml.io/"
SRC_URI="
	amd64? ( http://staruml.io/download/release/v${PV}/StarUML-v${PV}-64-bit.deb )
	x86? ( http://staruml.io/download/release/v${PV}/StarUML-v${PV}-32-bit.deb )
"

LICENSE="StarUML-EULA no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="splitdebug"

RDEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libgcrypt:11
	dev-libs/nss
	dev-libs/nspr
	gnome-base/gconf
	media-libs/fontconfig
	media-libs/freetype
	media-libs/alsa-lib
	net-print/cups
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libX11
	x11-libs/pango
	virtual/libudev
"

S="${WORKDIR}"
QA_PREBUILT="opt/staruml/Brackets-node opt/staruml/StarUML"

src_unpack() {
	unpack_deb ${A}
}

MY_PN=${PN/-bin/}
src_install() {
	mv opt "${ED}" || die
	dosym /usr/lib/libudev.so /opt/${MY_PN}/libudev.so.0
	dosym /opt/${MY_PN}/${MY_PN} /usr/bin/${MY_PN}
	newdoc usr/share/doc/${MY_PN}/copyright LICENSE
}
