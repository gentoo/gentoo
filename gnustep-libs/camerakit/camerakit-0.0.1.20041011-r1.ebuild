# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnustep-2

S=${WORKDIR}/${PN/camerak/CameraK}

DESCRIPTION="A simple wrapper to libgphoto2 for GNUstep"
HOMEPAGE="http://home.gna.org/gsimageapps/"
SRC_URI="http://download.gna.org/gsimageapps/${PN/camerak/CameraK}-${PV/0.0.1.}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"

DEPEND=">=media-libs/libgphoto2-2.1.3-r1"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i "s#/gphoto2#/usr/include/gphoto2#" GNUmakefile || die "sed failed"
}
